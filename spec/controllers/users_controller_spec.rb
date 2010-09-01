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
      # mock на save!, а не только на valid?, потому что без вызова
      # before_validation сохранение юзера падает (Authlogic)
      any_instance_of User, :valid? => true, :save! => true

      post 'create', :user => { :login => 'John', :email => 'john@com' }
      assigns[:user].login.should == 'John'
      assigns[:user].email.should == 'john@com'
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not register invalid user" do
      any_instance_of User, :valid? => false

      post 'create'
      response.should render_template 'new'
    end
  end

  %w{show edit}.each do |action|
    describe "##{action}" do
      it "should work" do
        mock(User).find('37') { Factory.build :user }

        get 'show', :id => 37
        response.should be_success
      end
    end
  end

  describe "#update" do |action|
    it "should apply good update" do
      mock(current_user).valid? { true }

      put 'update', :user => { :login => 'John', :email => 'john@com' }
      assigns[:user].login.should_not == 'John'
      assigns[:user].email.should == 'john@com'
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not apply bad update" do
      mock(current_user).valid? { false }

      put 'update', :user => {}
      response.should render_template 'edit'
    end
  end
end
