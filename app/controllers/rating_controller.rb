class RatingController < ApplicationController
  before_filter :require_user, :except => :users

  def firmwares
    @firmwares = Firmware.all_sorted_by_rating.paginate :page => params[:page], :per_page => Firmware.per_page
  end

  def users
    @users = User.all_sorted_by_rating.paginate :page => params[:page], :per_page => User.per_page
  end
end
