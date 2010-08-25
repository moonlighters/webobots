require 'spec_helper'

module AuthlogicSpecHelpers
  def current_user
    @current_user ||= Factory :user
  end

  def login
    current_user
    unless @current_session
      @current_session = stub!.record { current_user }
      stub(UserSession).find() { @current_session }
    end
  end

  def login_as_admin
    stub(current_user).admin? { true }
    login
  end

  def logout
    if @current_session
      @current_session = nil
      @current_user = nil
      stub(UserSession).find { nil }
    end
  end
end
