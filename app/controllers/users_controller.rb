class UsersController < ApplicationController
  before_filter :find_user, :only => [:edit, :update]

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    @user.login = params[:user][:login]
    if @user.save
      flash[:notice] = "Пользователь успешно зарегистрирован!"
      redirect_back_or_default account_url
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
  end

  def edit
  end
  
  def update
    params[:user].delete :login
    if @user.update_attributes params[:user]
      flash[:notice] = "Аккаунт обновлен!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
  def find_user
    @user = current_user
  end
end
