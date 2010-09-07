class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:index, :show, :edit, :update]

  before_filter :find_user, :only => [:edit, :update]
  before_filter :prepare_user_params, :only => [:create, :update]

  def index
    @users = User.paginate :page => params[:page], :order => 'lower(login)'
  end

  def new
    @user = User.new
    @user.code = params[:code]
  end

  def create
    # достаем логин заранее, чтобы избежать warning'а "присваивание protected поля"
    @user = User.new @user_params
    @user.login = @login

    # проверяем каптчу только в production'е
    if @user.valid? && ( !Rails.env.production? ||
                         verify_recaptcha(:model => @user, :message => "Каптча введена неверно") )
      @user.save!
      redirect_back_or_default account_url, :notice => "Пользователь успешно зарегистрирован"
    else
      render :action => :new
    end
  end

  def show
    @user = if params[:id]
              User.find params[:id]
            else
              current_user
            end
    @fws = @user.firmwares
    @users_count = User.count
    @comments = @user.comments.sorted.paginate :page => comments_page
  end

  def edit
  end

  def update
    if @user.update_attributes @user_params
      redirect_to account_url, :notice => "Аккаунт обновлен"
    else
      render :action => :edit
    end
  end

  private
  def find_user
    @user = current_user
  end

  def prepare_user_params
    @user_params = params[:user] || {}
    @login = @user_params.delete :login
  end
end
