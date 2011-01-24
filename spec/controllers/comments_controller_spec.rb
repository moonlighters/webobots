require 'spec_helper'

describe CommentsController do
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

  describe "#create" do
    before do
      @commentable = Factory.create :firmware
      mock(Firmware).find(37) { @commentable }
    end

    it "should create good comments" do
      any_instance_of Comment, :save => true

      post 'create', :comment => {:commentable_type => 'Firmware', :commentable_id => 37}
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not create bad comments" do
      any_instance_of Comment, :save => false

      post 'create', :comment => {:commentable_type => 'Firmware', :commentable_id => 37}
      response.should render_template 'new'
    end
  end

  describe "#destroy" do
    it "should not work when not logged in" do
      logout

      delete 'destroy', :id => 37
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should not work when not owner" do
      c = Comment.new
      mock(Comment).find('37') { c }
      mock(current_user).owns?(c) { false }

      delete 'destroy', :id => 37
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "should work when logged in as owner" do
      c = Comment.new
      mock(Comment).find('37') { c }
      mock(current_user).owns?(c) { true }
      mock(c).destroy
      mock(c).commentable { Factory.create :firmware }

      delete 'destroy', :id => 37
      response.should be_redirect
      flash[:notice].should_not be_nil
    end
  end
end
