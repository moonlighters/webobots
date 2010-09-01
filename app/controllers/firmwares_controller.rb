class FirmwaresController < ApplicationController
  before_filter :require_user
  before_filter :find_firmware, :only => [:show, :code, :edit, :update, :show_version, :index_versions]
  before_filter :require_owner, :only => [:edit, :update]
  before_filter :prepare_fwv_params, :only => [:create, :update]

  def index
    @fws = current_user.firmwares.paginate :page => params[:page], :order => 'id DESC'
  end

  def all
    @fws = Firmware.paginate :page => params[:page], :order => 'id DESC', :include => :user
  end

  def new
    @fw = Firmware.new
    @fwv = @fw.versions.build
  end

  def create
    @fw = current_user.firmwares.build params[:firmware]
    @fwv = @fw.versions.build @fwv_params
    if @fw.save
      redirect_to firmware_path(@fw), :notice => "Прошивка успешно создана"
    else
      render :action => :new
    end
  end

  def edit
    # В форму мы отдаем последнюю версию, удалив старый комментарий к версии
    @fwv.message = ""
  end

  def update
    # Добавляем новую версию только если код изменился
    if @fwv_params[:code] != @fwv.code
      @fwv = @fw.versions.build @fwv_params
    end

    if @fw.update_attributes params[:firmware]
      redirect_to firmware_path(@fw), :notice => "Прошивка успешно обновлена"
    else
      # В форму в любом случае надо вставить message
      @fwv.message = @fwv_params[:message]
      render :action => :edit
    end
  end

  def show
    @fws_count = Firmware.count
    @comments = @fw.comments.sorted.paginate :page => comments_page
  end

  def code
    if request.xhr?
      render :layout => false
    else
      redirect_to firmware_path(@fw)
    end
  end

  def index_versions
    @fwvs = @fw.versions.paginate :page => params[:page], :order => 'number DESC'
  end

  def show_version
    @fwv = @fw.versions.find_by_number! params[:number]
    @last_fwv = @fw.version
  end

  private
  def find_firmware
    @fw = Firmware.find params[:id]
    @fwv = @fw.version
  end

  def require_owner
    generalized_require_owner @fw
  end

  def prepare_fwv_params
    @fwv_params = (params[:firmware] || {}).delete(:firmware_version) || {}
  end
end
