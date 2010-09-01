require 'spec_helper'

describe MatchesController do
  include AuthlogicSpecHelpers
  integrate_views

  before { login }

  %w{index all}.each do |action|
    describe "##{action}" do
      it "should list items" do
        get action
        response.should be_success
      end
    end
  end

  describe "#all_for_user" do
    it "should list items" do
      mock(User).find('37') { Factory.build :user, :id => 37 }

      get 'all_for_user', :user_id => 37
      response.should be_success
    end
  end

  describe "#all_for_firmware" do
    it "should list items" do
      mock(Firmware).find('37') { Factory.build :firmware, :id => 37 }

      get 'all_for_firmware', :firmware_id => 37
      response.should be_success
    end
  end

  describe "#new" do
    it "should work if user has firmwares" do
      stub(current_user).firmwares { stub(Firmware).count { 2 }.subject }

      get 'new'
      response.should be_success
    end

    it "should notify user if he has no firmwares" do
      stub(current_user).firmwares { stub(Firmware).count { 0 }.subject }

      get 'new'
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should not work when not logged it" do
      logout

      get 'new'
      response.should be_redirect
      flash[:alert].should_not be_nil
    end
  end

  describe "#create" do
    it "should create good match" do
      any_instance_of Match, :save => true, :id => 37, :emulate => :draw

      post 'create'
      response.should be_redirect
    end

    it "should not create bad match" do
      any_instance_of Match, :save => false

      post 'create'
      response.should render_template 'new'
    end
  end

  describe "#show" do
    it "should work" do
      m = Factory :match
      stub(m).result { :draw }
      mock(Match).find('37') { m }

      get 'show', :id => 37
      response.should be_success
    end
  end

  describe "#play" do
    before do
      m = Factory.build :match, :id => 37, :result => :draw
      m.build_replay
      mock(Match).find('37') { m }
    end

    it "should play match if request.xhr?" do
      stub(request).xhr? { true }

      get 'play', :id => 37
      response.should be_success
    end

    it "should redirect to match path unless request.xhr?" do
      stub(request).xhr? { false }

      get 'play', :id => 37
      response.should be_redirect
    end
  end
end
