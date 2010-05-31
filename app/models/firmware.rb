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

  def version
    versions.last
  end

  attr_writer :rating_position
  def rating_position
    @rating_position ||= 1 + Firmware.count( :conditions => ['rating_points > ?', self.rating_points] )
  end
  
  def self.all_sorted_by_rating
    firmwares = Firmware.scoped :order => 'rating_points DESC',
                                :include => :user
    pos = 0
    val = nil
    firmwares.each_with_index do |fw, i|
      if fw.rating_points != val
        val = fw.rating_points
        pos = i + 1
      end
      fw.rating_position = pos
    end
  end
  
end
