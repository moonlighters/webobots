class Match < ActiveRecord::Base
  serialize :parameters, Hash

  belongs_to  :enemy_version,
              :class_name => "FirmwareVersion",
              :foreign_key => "fwv_id1"
  belongs_to  :friendly_version,
              :class_name => "FirmwareVersion",
              :foreign_key => "fwv_id2"

  def enemy
    self.enemy_version.firmware if self.enemy_version
  end

  def enemy=(fw)
    self.enemy_version = fw ? fw.versions.last : nil
  end

  def friendly 
    self.friendly_version.firmware if self.friendly_version
  end

  def friendly=(fw)
    self.friendly_version = fw ? fw.versions.last : nil
  end

  RESULTS = { :first => -1, :second => 1, :draw => 0 }
  def result=(symbol)
    super RESULTS[symbol]
  end

  def result
    RESULTS.index super
  end

  before_validation :generate_params

  validates_presence_of :fwv_id1, :fwv_id2

  validate do |m|
    message = 'не должна содержать синтаксических ошибок'
    m.errors.add :enemy, message if ! m.enemy_version.nil? && ! m.enemy_version.syntax_errors.empty?
    m.errors.add :friendly, message if ! m.friendly_version.nil? && ! m.friendly_version.syntax_errors.empty?
  end

  validates_presence_of :parameters
  validates_each :parameters, :allow_blank => true do |record, attr, value|
    def self.is_numeric?(obj)
      obj.is_a?(Fixnum) || obj.is_a?(Bignum) || obj.is_a?(Float)
    end
    valid = true
    unless  value.is_a?(Hash) &&
            value[:first].is_a?(Hash) &&
            value[:second].is_a?(Hash) &&
            is_numeric?(value[:seed])
      valid = false
    else 
      [:first, :second].each do |key|
          valid = false unless is_numeric?(value[key][:angle])
      
          [:x, :y].each do |coord|
            valid = false unless is_numeric?(value[key][coord])
          end
      end
    end
    record.errors.add attr, 'должен иметь правильный формат' unless valid
  end
 
  def emulate(logger)
    EmulationSystem.emulate enemy_version.code,
                            friendly_version.code,
                            parameters,
                            logger
                            
  end

  def winner_version
    case result
    when :first
      enemy_version
    when :second
      friendly_version
    else
      nil
    end
  end

  private

  def generate_params
    self.parameters ||= {
      :first => random_bot_hash,
      :second => random_bot_hash,
      :seed => (rand*100000).to_i
    }
  end

  def random_bot_hash
    { :x => rand, :y => rand, :angle => rand*360}
  end
end
