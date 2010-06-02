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

    if prevalidate( @match ) and @match.save
      redirect_to match_path( @match )
    else
      prepare_select
      render :action => :new
    end
  end

  def show
    unless @match.emulated?
      @logger = EmulationSystem::Loggers::DummyLogger.new
      @match.emulate @logger
    end
  end

  def play
    @logger = EmulationSystem::Loggers::ReplayLogger.new
    @match.emulate @logger
  end

  private

  def find_match
    @match = Match.find params[:id]
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
      @enemy_collection = user.firmwares.map do |x|
        [ x.name, x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игрока #{render_to_string :inline => "<%= link_to_user u %>", :locals => { :u => user }}"
    else
      @enemy_collection = Firmware.all(:order => :user_id).map do |x|
        [ "#{x.name} (игрока #{x.user.login})", x.version.id ]
      end
      @enemy_selection_hint = "одна из прошивок игроков"
    end
    @friendly_collection = current_user.firmwares.map do |x|
      [ x.name, x.version.id ]
    end
  end

  # в этом случае одна из прошивок должна принадлежать юзеру,
  # а те, что не принадлежат ему должны быть последней версии
  def prevalidate(match)
    u = match.user
    fwvs = %w[ first second ].map {|n| match.send "#{n}_version" }.compact
    owned = fwvs.select {|fwv| u.owns? fwv.firmware }
    not_owned = fwvs - owned
    if owned.count == 0
      match.errors.add_to_base "хотя бы одна из прошивок должна быть ваша"
      false
    elsif not_owned.any? {|fwv| fwv.firmware.versions.last != fwv }
      match.errors.add_to_base "нельзя проводить матчи со старыми версиями прошивок соперников"
      false
    else
      true
    end
  end
end
