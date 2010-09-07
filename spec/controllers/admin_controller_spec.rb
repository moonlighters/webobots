require 'spec_helper'

describe AdminController do
  include AuthlogicSpecHelpers
  integrate_views

  before{ login_as_admin }

  describe "#show" do
    it "should just do it" do
      get 'show'
      response.should be_success
    end
  end

  describe "#stats" do
    before { logout }

    it "should show stats when logged in as admin" do
      login_as_admin

      get 'stats'
      response.should be_success
    end

    it "should not show stats when logged in as usual user" do
      login

      get 'stats'
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "should not show stats when not logged in" do

      get 'stats'
      response.should_not be_success
      flash[:alert].should_not be_nil
    end
  end
end
