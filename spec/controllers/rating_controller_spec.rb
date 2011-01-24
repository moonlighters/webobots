require 'spec_helper'

describe RatingController do
  include AuthlogicSpecHelpers
  integrate_views

  describe "#users" do
    it "should work when logged in" do
      login
      get 'users'
      response.should be_success
    end

    it "should work when not logged in" do
      logout
      get 'users'
      response.should be_success
    end
  end

  describe "#firmwares" do
    it "should work when logged in" do
      login
      get 'firmwares'
      response.should be_success
    end

    it "should not work when not logged in" do
      logout
      get 'firmwares'
      response.should be_redirect
      flash[:alert].should_not be_nil
    end
  end
end
