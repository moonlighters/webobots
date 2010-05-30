class RatingController < ApplicationController
  def show_firmwares
    @firmwares = Firmware.all :order => "rating_points desc"
  end

  def show_users
    @users = User.all.sort {|x,y| x.rating_position <=> y.rating_position}
  end
end
