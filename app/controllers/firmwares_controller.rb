class FirmwaresController < ApplicationController
  before_filter :find_firmware, :only => [:show, :edit, :update, :show_version]

  before_filter :require_user
  before_filter :require_owner, :only => [:edit, :update]
  
  def index
    @fws = Firmware.all
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

      flash[:notice] = "Прошивка успешно создана!"
      redirect_to firmware_path(@fw)
    else
      render :action => :new
    end
  end

  def show
  end

  def show_version
    @fwv = FirmwareVersion.find_by_firmware_id_and_number! @fw, params[:number]
  end

  def edit
    # В форму мы отдаем последнюю версию
    @fwv = @fw.versions.last
  end

  def update
    # А сохранять уже будем как новую версию
    @fwv = FirmwareVersion.new params[:firmware].delete :firmware_version
    if @fw.update_attributes params[:firmware]
      # Если код не изменен, то версию обновлять вовсе не нужно
      if @fwv.code != @fw.versions.last.code
        @fwv.firmware = @fw
        # Модель FirmwareVersion сделана так, что ошибок быть не может
        @fwv.save!
      end

      flash[:notice] = "Прошивка успешно обновлена!"
      redirect_to firmware_path(@fw)
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
