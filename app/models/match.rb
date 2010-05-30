class Match < ActiveRecord::Base
  serialize :parameters, Hash

  belongs_to  :first_version,
              :class_name => 'FirmwareVersion',
              :foreign_key => 'fwv1_id'
  belongs_to  :second_version,
              :class_name => 'FirmwareVersion',
              :foreign_key => 'fwv2_id'

  belongs_to :user

  before_validation :generate_parameters

  validates_presence_of :first_version, :second_version, :parameters

  validate do |m|
    message = "не должна содержать синтаксических ошибок"
    m.errors.add :first_version, message if ! m.first_version.nil? && ! m.first_version.syntax_errors.empty?
    m.errors.add :second_version, message if ! m.second_version.nil? && ! m.second_version.syntax_errors.empty?

    # если юзер есть, то хотя бы одна из прошивок должна принадлежать ему
    if !m.user.nil? && !m.first_version.nil? && !m.second_version.nil? &&
      ![m.first_version, m.second_version].any? {|fwv| m.user.owns? fwv.firmware }
      m.errors.add_to_base "хотя бы одна из прошивок должна быть ваша"
    end

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
    EmulationSystem.emulate first_version.code,
                            second_version.code,
                            parameters,
                            logger
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

  private

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
