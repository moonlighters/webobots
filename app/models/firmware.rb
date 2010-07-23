class Firmware < ActiveRecord::Base
  has_many :versions, :class_name => 'FirmwareVersion', :order => 'number', :dependent => :destroy do
    # Номер последней прошивки (+nil+, если версий нет)
    def last_number
      last.number unless empty?
    end
  end
  has_one :version, :class_name => 'FirmwareVersion', :order => 'number DESC'

  belongs_to :user

  cattr_reader :per_page
  @@per_page = 10
  cattr_reader :per_page_of_rating
  @@per_page_of_rating = 10

  validates_presence_of :name, :user_id
  validates_length_of :name, :maximum => 40
  validates_uniqueness_of :name, :scope => :user_id,
    :message => "у Вас уже есть прошивка с таким именем"

  # TODO: может быть стоит занести это в модель?
  # validates :presence_of_at_least_one_version

  named_scope :available_for, lambda { |user|
    { :conditions => ["available = ? OR user_id = ?", true, user] }
  }

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
