require 'spec_helper'

describe RatingController do
  include AuthlogicSpecHelpers
  integrate_views

  %w{firmwares users}.each do |action|
    describe "##{action}" do
      it "should work when logged in" do
        login
        get action
        response.should be_success
      end

      it "should not work when not logged in" do
        logout
        get action
        response.should be_redirect
        flash[:alert].should_not be_nil
      end
    end
  end
end
