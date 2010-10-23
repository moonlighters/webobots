class MatchesController < ApplicationController
  before_filter :require_user
  before_filter :find_match, :only => [:show, :play]
  before_filter :find_user, :only => [:all_for_user]
  before_filter :find_firmware, :only => [:all_for_firmware]

  def index
    @matches = current_user.matches.paginate_including_stuff :page => params[:page]
  end

  def all
    @matches = Match.paginate_including_stuff :page => params[:page]
  end

  def all_for_user
    @user = User.find_friendly params[:user_id]
    @matches = @user.matches.paginate_including_stuff :page => params[:page]

    @has_firmwares = @user.firmwares.count > 0
  end

  def all_for_firmware
    @user = User.find_friendly params[:user_id]
    @fw = @user.firmwares.find params[:firmware_id], :scope => @user.to_param
    @matches = @fw.matches.paginate_including_stuff :page => params[:page]
  end

  def new
    prepare_select

    @match = Match.new :first_version => ( @fw.version if @fw )
    if current_user.firmwares.count == 0
      redirect_to new_user_firmware_path(current_user), :notice => "Сначала создайте прошивку для участия в матчах"
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
  end

  def find_user
    @user = User.find_friendly params[:user_id]
  end

  def find_firmware
    find_user
    @fw = @user.firmwares.find_friendly params[:firmware_id], :scope => @user.to_param
  end

  def prepare_select
    if params[:enemy]
      @user = User.find_friendly params[:enemy]

      if params[:enemy_fw]
        @fw = @user.firmwares.find_friendly params[:enemy_fw], :scope => @user.to_param
      end
    end
    @enemy_id = @user.to_param if @user

    if @user
      @enemy_fws = @user.firmwares.scoped(:include => :version).available_for current_user
      @enemy_collection = @enemy_fws.map do |x|
        [ x.name, x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игрока #{render_to_string :inline => "<%= link_to_user u %>", :locals => { :u => @user }}"
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
