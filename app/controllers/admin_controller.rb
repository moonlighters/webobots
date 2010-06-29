class AdminController < ApplicationController
  before_filter :require_admin

  def show
  end

  def stats
    @users_count = User.count
    @fws_count = Firmware.count
    @matches_count = Match.count
  end
end
