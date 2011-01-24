require 'spec_helper'

describe FirmwaresController do
  include AuthlogicSpecHelpers
  integrate_views

  before do
    login
    @user = Factory.build :user
    stub(User).find_friendly('John') { @user }

    @fw = Factory.build :firmware, :id => 37, :user => @user
    @fwv = Factory.build :firmware_version, :number => 13, :firmware => @fw, :created_at => Time.now
    stub(@fw).version { @fwv }
  end

  %w{index new}.each do |action|
    describe "##{action}" do
      it "should work" do
        get action, :user_id => 'John'
        response.should be_success
      end
    end
  end

  %w{show index_versions}.each do |action|
    describe "##{action}" do
      it "should work" do
        mock_find

        get action, :user_id => 'John', :id => 'The Firmware'
        response.should be_success
      end
    end
  end

  describe '#create' do
    it "should create good firmware" do
      any_instance_of Firmware, :save => true, :id => 37

      post 'create', :user_id => 'John'
      response.should be_redirect
    end

    it "should not create bad firmware" do
      any_instance_of Firmware, :save => false

      post 'create', :user_id => 'John'
      response.should render_template 'new'
    end
  end

  describe '#edit' do
    it "should not work when not logged in" do
      logout

      get 'edit', :user_id => 'John', :id => 'The Firmware'
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should not work when not owner" do
      mock_find
      mock(current_user).owns?(@fw).times(any_times) { false }

      get 'edit', :user_id => 'John', :id => 'The Firmware'
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should work when logged in as owner" do
      mock_find
      mock(current_user).owns?(@fw).times(any_times) { true }

      get 'edit', :user_id => 'John', :id => 'The Firmware'
      response.should be_success
    end
  end

  describe '#update' do
    before do
      mock_find
      mock(current_user).owns?(@fw).times(any_times) { true }
    end

    it "should save good update" do
      mock(@fw).save { true }

      put 'update', :user_id => 'John', :id => 'The Firmware'
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not save bad update" do
      mock(@fw).save { false }

      put 'update', :user_id => 'John', :id => 'The Firmware'
      response.should render_template 'edit'
    end
  end

  describe "code" do
    before { mock_find }

    it "should give code when request.xhr?" do
      stub(request).xhr? { true }

      get 'code', :user_id => 'John', :id => 'The Firmware'
      response.should be_success
    end

    it "should redirect to firmware path when not request.xhr?" do
      stub(request).xhr? { false }

      get 'code', :user_id => 'John', :id => 'The Firmware'
      response.should be_redirect
    end
  end

  describe "show_version" do
    it "should work" do
      mock_find
      mock(FirmwareVersion).find(:first, {:conditions => { :number => '42' }}) { @fwv }

      get 'show_version', :user_id => 'John', :id => 'The Firmware', :number => 42
    end
  end

  def mock_find
    mock(@user).firmwares { mock!.find_friendly('The Firmware') { @fw } }
  end
end
