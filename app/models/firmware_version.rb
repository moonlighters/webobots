class FirmwareVersion < ActiveRecord::Base
  belongs_to :firmware, :touch => true
  has_one :user, :through => :firmware
  has_many :matches, :finder_sql => %q{
    SELECT * FROM matches
    WHERE (matches.fwv1_id = #{id} OR matches.fwv2_id = #{id})
  }

  cattr_reader :per_page
  @@per_page = 10

  # this is validated by sql (needed for nested building)
  #validates_presence_of :firmware

  validates_presence_of :number
  validates_uniqueness_of :number, :scope => :firmware_id
  validates_length_of :code, :maximum => 64.kilobytes - 1
  validates_length_of :message, :maximum => 500, :allow_nil => true

  before_validation :correct_code
  # NB! Номера могут быть не уникальны в течении времени
  before_validation :generate_number

  def syntax_errors
    @syntax_errors ||= check_syntax_errors
  end

  private

  # Гарантия <tt>code != nil</tt>
  def correct_code
    self.code ||= ""
  end

  # Задать версии номер
  def generate_number
    unless number
      self.number = firmware ? (firmware.versions.last_number || 0) + 1 : 1
    end
  end

  # Возвращает массив синтаксических ошибок
  #
  # Массив пустой, если ошибок нет
  def check_syntax_errors
    EmulationSystem.check_syntax_errors(code)
  end
end
