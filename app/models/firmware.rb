class Firmware < ActiveRecord::Base
  has_many :versions, :class_name => 'FirmwareVersion', :order => 'number', :dependent => :destroy do
    # Номер последней прошивки (+nil+, если версий нет)
    def last_number
      last.number unless empty?
    end
  end

  belongs_to :user

  validates_presence_of :name, :user_id

  # TODO: может быть стоит занести это в модель?
  # validates :presence_of_at_least_one_version

  def syntax_errors
    @syntax_errors ||= check_syntax_errors
  end
  
  private

  def check_syntax_errors
    EmulationSystem.check_syntax_errors(versions.last.code)
  end
end
