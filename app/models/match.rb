class Match < ActiveRecord::Base
  serialize :parameters, Hash

  belongs_to  :first,
              :class_name => "FirmwareVersion",
              :foreign_key => "fwv_id1"
  belongs_to  :second,
              :class_name => "FirmwareVersion",
              :foreign_key => "fwv_id2"

  before_validation :generate_params

  validates_presence_of :fwv_id1, :fwv_id2

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
