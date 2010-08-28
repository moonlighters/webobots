class MatchesController < ApplicationController
  before_filter :require_user
  before_filter :find_match, :only => [:show, :play]

  def index
    @matches = current_user.matches.paginate_including_stuff :page => params[:page]
  end

  def all
    @matches = Match.paginate_including_stuff :page => params[:page]
  end

  def all_for_user
    @user = User.find params[:user_id]
    @matches = @user.matches.paginate_including_stuff :page => params[:page]

    @has_firmwares = @user.firmwares.count > 0
  end

  def all_for_firmware
    @fw = Firmware.find params[:firmware_id]
    @matches = @fw.matches.paginate_including_stuff :page => params[:page]
  end

  def new
    prepare_select

    @match = Match.new :first_version => (
      Firmware.find(params[:enemy_fw]).version if params[:enemy_fw]
    )
    if current_user.firmwares.count == 0
      redirect_to firmwares_path, :alert => "Сначала создайте прошивку для участия в матчах"
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
    @comments = @match.comments.sorted.paginate :page => comments_page
  end

  def play
    if request.xhr?
      @match.emulate( EmulationSystem::Loggers::ReplayLogger.new ) if @match.replay.nil?
      @replay = @match.replay
      render :layout => false
    else
      redirect_to match_path(@match)
    end
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
      @enemy_fws = user.firmwares.scoped(:include => :version).available_for current_user
      @enemy_collection = @enemy_fws.map do |x|
        [ x.name, x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игрока #{render_to_string :inline => "<%= link_to_user u %>", :locals => { :u => user }}"
    else
      @enemy_fws = Firmware.scoped(
        :order => :user_id, :include => [:user, :version]
      ).available_for current_user
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
