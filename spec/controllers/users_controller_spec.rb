require 'spec_helper'

describe UsersController do
  include AuthlogicSpecHelpers
  integrate_views

  before { login }

  describe "#index" do
    it "should work" do
      get 'index'
      response.should be_success
    end
  end

  describe "#new" do
    it "should work" do
      logout
      
      get 'new'
      response.should be_success
    end
  end

  describe "#create" do
    before { logout }

    it "should register valid user" do
      any_instance_of User, :valid? => true
      # mock на save!, а не только на valid?, потому что без вызова
      # before_validation сохранение юзера падает (Authlogic)
      any_instance_of User, :save! => true
      
      # код '1234': используем глобальный хак для инвайтов...
      post 'create', :user => {:code => '1234'}
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not register invalid user" do
      any_instance_of User, :valid? => false
      
      post 'create', :user => {}
      response.should render_template 'new'
    end
  end

  %w{show edit}.each do |action|
    describe "##{action}" do
      it "should work" do
        u = Factory :user
        mock(User).find('37') { u }

        get 'show', :id => 37
        response.should be_success
      end
    end
  end

  describe "#update" do |action|
    it "should apply good update" do
      mock(current_user).valid?.times(any_times) { true }

      put 'update', :user => {}
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not apply bad update" do
      mock(current_user).valid?.times(any_times) { false }

      put 'update', :user => {}
      response.should render_template 'edit'
    end
  end
end
