class MatchesController < ApplicationController
  before_filter :require_user
  before_filter :find_match, :only => [:show, :play]

  def index
    @matches = Match.all_including_stuff_for(current_user).paginate :page => params[:page],
      :total_entries => Match.count_for(current_user)
  end

  def all
    @matches = Match.all_including_stuff.paginate :page => params[:page],
      :total_entries => Match.count
  end

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
      @match.emulate EmulationSystem::Loggers::ReplayLogger.new

      redirect_to match_path( @match )
    else
      prepare_select
      render :action => :new
    end
  end

  def show
  end

  def play
    @match.emulate( EmulationSystem::Loggers::ReplayLogger.new ) if @match.replay.nil?
    @replay = @match.replay
  end

  private

  def find_match
    @match = Match.find params[:id]
    render( :action => :show_with_error ) if @match.failed?
  end

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
      @enemy_fws = user.firmwares.scoped(:include => :version).select_available_for current_user
      @enemy_collection = @enemy_fws.map do |x|
        [ x.name, x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игрока #{render_to_string :inline => "<%= link_to_user u %>", :locals => { :u => user }}"
    else
      @enemy_fws = Firmware.scoped(
        :order => :user_id, :include => [:user, :version]
      ).select_available_for current_user
      @enemy_collection = @enemy_fws.map do |x|
        [ "#{x.name} (игрока #{x.user.login})", x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игроков"
    end

    @friendly_collection = current_user.firmwares.scoped(:include => :version).map do |x|
      [ x.name, x.version.id ]
    end
  end
end
