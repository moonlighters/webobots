class FirmwareVersion < ActiveRecord::Base
  belongs_to :firmware, :touch => true

  validates_presence_of :firmware_id, :number, :code
  
  # NB! Номера могут быть не уникальны в течении времени
  before_validation :generate_number

  private

  # Задать версии номер
  def generate_number
    self.number = (self.firmware.versions.last_number || 0) + 1 if not self.number and self.firmware
  end
end
