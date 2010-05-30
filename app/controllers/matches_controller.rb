class MatchesController < ApplicationController
  before_filter :require_user

  def new
    prepare_select

    @match = Match.new :first_version => (
      Firmware.find(params[:enemy_fw]).version if params[:enemy_fw]
    )
    if current_user.firmwares.count == 0
      flash[:error] = "Сначала создайте прошивку для участия в матчах"
      redirect_to firmwares_path
    end
  end

  def create
    @match = Match.new params[:match]
    @match.user = current_user
    if @match.save
      redirect_to match_path( @match )
    else
      prepare_select
      render :action => :new
    end
  end

  def show
    @match = Match.find params[:id]
    @logger = EmulationSystem::Loggers::RecordListLogger.new
    res = @match.emulate @logger
    unless @match.result
      @match.result = res
      @match.save! # must be no errors
    end
  end

  private

  def prepare_select
    if params[:enemy]
      user = User.find params[:enemy]
    end

    if params[:enemy_fw]
      fw = Firmware.find params[:enemy_fw]
      user = fw.user
    end
    @enemy_id = user.id if user

    if user
      @enemy_collection = user.firmwares.map do |x|
        [ x.name, x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игрока #{render_to_string :inline => "<%= link_to_user u %>", :locals => { :u => user }}"
    else
      @enemy_collection = Firmware.all(:order => :user_id).map do |x|
        [ "#{x.user.login} -- #{x.name}", x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игроков"
    end
    @friendly_collection = current_user.firmwares.map do |x|
      [ x.name, x.version.id ]
    end
  end
end
