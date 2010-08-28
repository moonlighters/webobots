require 'spec_helper'

describe CommentsController do
  include AuthlogicSpecHelpers

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
      @commentable = Factory :firmware
      mock(Firmware).find(37) { @commentable }
    end

    it "should create good comments" do
      any_instance_of Comment, :valid? => true

      post 'create', :comment => {:commentable_type => 'Firmware', :commentable_id => 37}
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not create bad comments" do
      any_instance_of Comment, :valid? => false

      post 'create', :comment => {:commentable_type => 'Firmware', :commentable_id => 37}
      response.should render_template 'new'
    end
  end

  describe "#destroy" do
    it "should not work when not logged in" do
      stub(Comment).find('37') { stub!.subject }
      logout

      delete 'destroy', :id => 37
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should not work when not owner" do
      stub(Comment).find('37') { mock(Comment.new).user{ Factory :user }.subject }
      
      delete 'destroy', :id => 37
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "should work when logged in as owner" do
      comment = mock(Comment.new).destroy.subject
      stub(comment).commentable { Factory :firmware }
      mock(current_user).owns?(comment) { true }
      stub(Comment).find('37') { comment }

      delete 'destroy', :id => 37
      response.should be_redirect
      flash[:notice].should_not be_nil
    end
  end
end
