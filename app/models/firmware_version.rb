class FirmwareVersion < ActiveRecord::Base
  belongs_to :firmware, :touch => true
  has_one :user, :through => :firmware

  cattr_reader :per_page
  @@per_page = 10

  validates_presence_of :firmware_id, :number
  validates_uniqueness_of :number, :scope => :firmware_id

  before_validation :correct_code
  # NB! Номера могут быть не уникальны в течении времени
  before_validation :generate_number

  def syntax_errors
    @syntax_errors ||= check_syntax_errors
  end

  private

  # Чтобы пустые версии тоже могли существовать,
  # но +code+ все равно всегда != nil
  def correct_code
    self.code ||= ""
  end

  # Задать версии номер
  def generate_number
    self.number = (self.firmware.versions.last_number || 0) + 1 if not self.number and self.firmware
  end

  # Возвращает массив синтаксических ошибок
  #
  # Массив пустой, если ошибок нет
  def check_syntax_errors
    EmulationSystem.check_syntax_errors(code)
  end
end
