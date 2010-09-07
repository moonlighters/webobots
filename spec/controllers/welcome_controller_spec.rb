require 'spec_helper'

describe WelcomeController do
  integrate_views

  describe "#root" do
    it "should work" do
      get 'root'
      response.should be_success
    end
  end
end
