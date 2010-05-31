class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :login
    config.validates_format_of_login_field_options = {
      :with => /^\w[-._\w\d]+$/,
      :message => "должен содержать только буквы, цифры и .-_"
    }
  end

  attr_protected :login

  has_many :firmwares
  has_many :matches

  attr_writer :rating_points
  def rating_points
    @rating_points ||= firmwares.sum( :rating_points )
  end
  
  attr_writer :rating_position
  def rating_position
    @rating_position ||=
      begin
        user_points = Firmware.sum :rating_points, :joins => :user, :group => :user_id
        1 + user_points.count {|_,points| points > user_points.fetch(self.id, 0.0) }
      end
  end

  def owns?(obj)
    obj.respond_to? :user and obj.user == self
  end

  def self.all_sorted_by_rating
    users = User.scoped :select => 'users.*,SUM(rating_points) as sum_rating_points',
                        :joins => 'LEFT OUTER JOIN firmwares ON firmwares.user_id = users.id',
                        :group => 'users.id',
                        :order => 'sum_rating_points DESC'
    pos = 0
    val = nil
    users.each_with_index do |u, i|
      u.rating_points = (u.sum_rating_points || 0.0).to_f
      if u.rating_points != val
        val = u.rating_points
        pos = i + 1
      end
      u.rating_position = pos
    end
  end
  
end
