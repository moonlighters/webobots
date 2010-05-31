class Match < ActiveRecord::Base
  serialize :parameters, Hash

  belongs_to  :first_version,
              :class_name => 'FirmwareVersion',
              :foreign_key => 'fwv1_id'
  belongs_to  :second_version,
              :class_name => 'FirmwareVersion',
              :foreign_key => 'fwv2_id'

  belongs_to :user

  def self.all_including_stuff
    self.all_including_stuff_for nil
  end

  named_scope :all_including_stuff_for, lambda { |user|
    {
      :order => 'id DESC',
      :include => {
        :first_version => {:firmware => :user},
        :second_version => {:firmware => :user}
      }
    }.merge(
      user ? {
        :select => 'DISTINCT matches.*',
        :joins => 'JOIN firmware_versions ON firmware_versions.id IN (matches.fwv1_id, matches.fwv2_id)
                   JOIN firmwares ON firmwares.id = firmware_versions.firmware_id
                   JOIN users ON users.id = firmwares.user_id',
        :conditions => {'users.id' => user}
      } : {})
  }


  before_validation :generate_parameters

  validates_presence_of :first_version, :second_version, :parameters

  validate do |m|
    message = "не должна содержать синтаксических ошибок"
    m.errors.add :first_version, message if ! m.first_version.nil? && ! m.first_version.syntax_errors.empty?
    m.errors.add :second_version, message if ! m.second_version.nil? && ! m.second_version.syntax_errors.empty?

    unless m.parameters.nil?
      p = m.parameters
      unless p.is_a? Hash and
             p[:seed].is_a? Numeric and
             p[:first].is_a? Hash and
             p[:second].is_a? Hash and
             [:first, :second].all? do |key|
               [:x, :y, :angle].all? do |subkey|
                 p[key][subkey].is_a? Numeric
               end
             end
        m.errors.add :parameters, "должны иметь правильный формат"
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
 
  def emulate(logger)
    res = EmulationSystem.emulate first_version.code,
                                  second_version.code,
                                  parameters,
                                  logger
    unless result
      set_result!(res)
    end

    result
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
    self.parameters ||= {
      :first => random_bot_hash,
      :second => random_bot_hash,
      :seed => srand
    }
  end

  def random_bot_hash
    { :x => rand, :y => rand, :angle => rand*360}
  end
end
