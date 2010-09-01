require 'spec_helper'

describe UserSessionsController do
  include AuthlogicSpecHelpers
  integrate_views

  describe "#new" do
    it "should work" do
      logout

      get 'new'
      response.should be_success
    end
  end

  describe "#create" do
    it "should login user with correct login & pass" do
      logout
      any_instance_of UserSession, :save => true

      post 'create'
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not login user with incorrect login & pass" do
      logout
      any_instance_of UserSession, :save => false

      post 'create'
      response.should render_template 'new'
    end
  end

  describe "#destroy" do
    it "should logout if logged in" do
      login

      delete 'destroy'
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not do anything when not logged it" do
      logout

      delete 'destroy'
      response.should be_redirect
      flash[:alert].should_not be_nil
    end
  end
end
