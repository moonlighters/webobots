class FirmwaresController < ApplicationController
  before_filter :find_firmware, :only => [:show, :edit, :update, :show_version, :index_versions]

  before_filter :require_user
  before_filter :require_owner, :only => [:edit, :update]
  
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
    @fwv = FirmwareVersion.new params[:firmware].delete :firmware_version
    @fw = Firmware.new params[:firmware]
    @fw.user = current_user
    if @fw.save
      @fwv.firmware = @fw
      # Модель FirmwareVersion сделана так, что ошибок быть не может
      @fwv.save!

      redirect_to firmware_path(@fw), :notice => "Прошивка успешно создана"
    else
      render :action => :new
    end
  end

  def show
    @fws_count = Firmware.count
    @fwv = @fw.version
    @comments = @fw.comments.sorted.paginate :page => comments_page
  end

  def index_versions
    @fwvs = @fw.versions.paginate :page => params[:page], :order => 'number DESC'
  end

  def show_version
    @fwv = @fw.versions.find_by_number! params[:number]
    if @fwv == @fw.version
      redirect_to firmware_path @fw
    else
      render
    end
  end

  def edit
    # В форму мы отдаем последнюю версию
    @fwv = @fw.version
  end

  def update
    # А сохранять уже будем как новую версию
    @fwv = FirmwareVersion.new params[:firmware].delete :firmware_version
    if @fw.update_attributes params[:firmware]
      # Если код не изменен, то версию обновлять вовсе не нужно
      if @fwv.code != @fw.version.code
        @fwv.firmware = @fw
        # Модель FirmwareVersion сделана так, что ошибок быть не может
        @fwv.save!
      end

      redirect_to firmware_path(@fw), :notice => "Прошивка успешно обновлена"
    else
      render :action => edit
    end
  end

  private
  def find_firmware
    @fw = Firmware.find params[:id]
  end

  def require_owner
    generalized_require_owner @fw
  end
end
