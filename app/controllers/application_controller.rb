class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  LogBuddy.init

  class NotFound < StandardError; end

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
      redirect_to login_url, :alert => "Вы должны войти, чтобы получить доступ к этой странице"
      false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to root_url, :alert => "Вы должны выйти из системы, чтобы получить доступ к этой странице"
      false
    end
  end

  def require_admin
    return false if require_user == false

    unless current_user.admin?
      store_location
      redirect_to root_url, :alert => "У вас недостаточно прав, чтобы получить доступ к этой странице"
      false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default, opts={})
    redirect_to(session[:return_to] || default, opts)
    session[:return_to] = nil
  end

  def generalized_require_owner(resource)
    unless current_user and current_user.owns? resource
      redirect_back_or_default root_path, :alert => "У вас нет доступа к этой странице"
      false
    end
  end

  # Вывод страниц с ошибкой
  def rescue_action_in_public(e)
    case e
    when NotFound,
         ActiveRecord::RecordNotFound,
         ActionController::UnknownController,
         ActionController::UnknownAction,
         ActionController::RoutingError
      render 'application/404', :status => 404
    else
      render :file => File.join(Rails.root, 'public', '500.html'),
             :status => 500
    end
  end

  def comments_page
    params[:comments_page]
  end
end
