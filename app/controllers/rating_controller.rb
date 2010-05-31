class RatingController < ApplicationController
  def show_firmwares
    @firmwares = Firmware.all_sorted_by_rating
  end

  def show_users
    @users = User.all_sorted_by_rating
  end
end
