require 'spec_helper'

describe InvitesController do
  include AuthlogicSpecHelpers
  integrate_views

  before { login_as_admin }

  describe "#index" do
    before { logout }

    it "should work when logged in as admin" do
      login_as_admin

      get 'index'
      response.should be_success
    end

    it "should not work when logged in usual user" do
      login
      
      get 'index'
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "should not work when not logged in" do
      get 'index'
      response.should_not be_success
      flash[:alert].should_not be_nil
    end
  end

  describe "#create" do
    it "should create good ones" do
      any_instance_of Invite, :valid? => true

      post 'create'
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not create bad ones" do
      any_instance_of Invite, :valid? => false

      post 'create'
      response.should be_redirect
      flash[:alert].should_not be_nil
    end
  end

  describe "#destroy" do
    it "should destroy" do
      stub(Invite).find('37') { mock(Invite.new).destroy.subject }
      
      delete 'destroy', :id => 37
      response.should be_redirect
      flash[:notice].should_not be_nil
    end
  end
end
