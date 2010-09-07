class Match < ActiveRecord::Base
  serialize :parameters, Hash

  has_one :replay, :class_name => 'MatchReplay'

  belongs_to  :first_version,
              :class_name => 'FirmwareVersion',
              :foreign_key => 'fwv1_id'
  belongs_to  :second_version,
              :class_name => 'FirmwareVersion',
              :foreign_key => 'fwv2_id'

  belongs_to :user

  acts_as_commentable

  JOINS_FOR_FIRMWARE = 'JOIN firmware_versions ON firmware_versions.id IN (matches.fwv1_id, matches.fwv2_id)
                        JOIN firmwares ON firmwares.id = firmware_versions.firmware_id'
  JOINS_FOR_USER = JOINS_FOR_FIRMWARE + ' JOIN users ON users.id = firmwares.user_id'

  # obj is a User or Firmware
  named_scope :all_for, lambda { |obj|
    klass = obj.class
    {
      :select => 'DISTINCT matches.*',
      :joins => "Match::JOINS_FOR_#{klass.to_s.upcase}".constantize,
      :conditions => {"#{klass.table_name}.id" => obj}
    }
  }

  named_scope :including_stuff, :order => 'id DESC',
                                :include => {
                                  :first_version => {:firmware => :user},
                                  :second_version => {:firmware => :user}
                                }

  def self.paginate_including_stuff(opts)
    self.including_stuff.paginate opts.reverse_merge(:total_entries => self.count)
  end

  cattr_reader :per_page
  @@per_page = 10

  before_validation :generate_parameters

  validates_presence_of :first_version, :second_version, :parameters, :vm_version
  validates_presence_of :user unless Rails.env.test?

  # Проверяет:
  # * одна из прошивок должна принадлежать +user+
  # * версии прошивок, не принадлежащих +user+, должны быть последними
  # * прошивки, не принадлежащие +user+, должны быть доступны для сражения
  # * версии прошивок не должны содержать синтаксических ошибок
  # * +parameters+ должны иметь верный формат
  def validate
    u = self.user
    fwvs = %w[ first second ].map {|n| send "#{n}_version" }.compact
    owned = unless u.nil?
              fwvs.select {|fwv| u.owns? fwv.firmware }
            else
              []
            end
    not_owned = fwvs - owned
    if owned.count == 0 && !u.nil?
      errors.add_to_base "хотя бы одна из прошивок должна быть ваша"
    end
    if not_owned.any? {|fwv| fwv.firmware.versions.last != fwv }
      errors.add_to_base "нельзя проводить матчи со старыми версиями прошивок соперников"
    end
    if not_owned.any? {|fwv| not fwv.firmware.available?}
      errors.add_to_base "прошивка соперника недоступна для сражения"
    end

    message = "не должна содержать синтаксических ошибок"
    errors.add :first_version, message if ! first_version.nil? && ! first_version.syntax_errors.empty?
    errors.add :second_version, message if ! second_version.nil? && ! second_version.syntax_errors.empty?

    unless parameters.nil?
      p = parameters
      unless p.is_a? Hash and
             p[:seed].is_a? Numeric and
             p[:first].is_a? Hash and
             p[:second].is_a? Hash and
             [:first, :second].all? do |key|
               [:x, :y, :angle].all? do |subkey|
                 p[key][subkey].is_a? Numeric
               end
             end
        errors.add :parameters, "должны иметь правильный формат"
      end
    end
  end

  RESULTS = { :first => -1, :second => 1, :draw => 0 }
  def result=(symbol)
    super( RESULTS[symbol] )
  end
  def result
    RESULTS.index( super )
  end

  def draw?
    result == :draw
  end

  def emulate(logger)
    begin
      res = EmulationSystem.emulate first_version.code,
                                    second_version.code,
                                    parameters,
                                    logger
    rescue EmulationSystem::Errors::WFLRuntimeError => e
      self.rt_error_msg = e.message
    end

    set_result!(res) unless result

    if logger.is_a? EmulationSystem::Loggers::ReplayLogger and replay.nil?
      create_replay :config => logger.config, :frames => logger.frames
    end
    result
  end

  def emulated?
    not result.nil?
  end

  def failed?
    not rt_error_msg.blank?
  end

  def winner_version
    case result
    when :first
      first_version
    when :second
      second_version
    else
      nil
    end
  end

  def winner_points
    case result
    when :first
      first_points
    when :second
      second_points
    else
      nil
    end
  end

  private

  def set_result!(res)
    fw1 = first_version.firmware
    fw2 = second_version.firmware

    self.result = res
    if fw1.user != fw2.user
      case result
      when :first
        self.first_points, self.second_points = Rating.points_for *[fw1, fw2].map(&:rating_points)
      when :second
        self.second_points, self.first_points = Rating.points_for *[fw2, fw1].map(&:rating_points)
      else
        self.first_points, self.second_points = 0, 0
      end
    end
    save!
    fw1.rating_points += first_points
    fw1.save!
    fw2.rating_points += second_points
    fw2.save!
  end

  def generate_parameters
    self.parameters ||= EmulationSystem.generate_vm_params
    self.vm_version = EmulationSystem::Emulation::VM::VERSION
  end
end
