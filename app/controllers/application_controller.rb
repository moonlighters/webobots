class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "Вы должны войти, чтобы получить доступ к этой странице"
      redirect_to login_url
      false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "Вы должны выйти из системы, чтобы получить доступ к этой странице"
      # TODO redirect_to root ?
      redirect_to account_url
      false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
