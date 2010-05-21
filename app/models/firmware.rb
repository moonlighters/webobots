class Firmware < ActiveRecord::Base
  has_many :versions, :class_name => 'FirmwareVersion', :order => 'number', :dependent => :destroy do
    # Номер последней прошивки (+nil+, если версий нет)
    def last_number
      last.number unless empty?
    end
  end
  accepts_nested_attributes_for :versions

  belongs_to :user

  validates_presence_of :name, :user_id
end
