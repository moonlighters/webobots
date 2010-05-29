class MatchesController < ApplicationController
  before_filter :require_user
  before_filter :prepare_collections, :only => [:choose_yours, :create]

  def choose_yours
    @match = Match.new :enemy => Firmware.find(params[:enemy_id])
    unless @friendly_collection.empty?
      render
    else
      flash[:error] = "Сначала создайте прошивку для участия в матче"
      redirect_to firmwares_path
    end
  end

  def create
    @enemy = Firmware.find params[:match][:enemy]
    @friendly = Firmware.find params[:match][:friendly]
    @match = Match.new :enemy => @enemy, :friendly => @friendly
    if @match.friendly.user != current_user
      @match.errors.add :friendly, 'должна принадлежать тому, кто проводит матч'
      render :action => :choose_yours
    else
      if @match.save
        redirect_to match_path(@match)
      else
        render :action => :choose_yours
      end
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
  def prepare_collections
    @enemy_collection = Firmware.all
    @friendly_collection = current_user.firmwares
  end
end
