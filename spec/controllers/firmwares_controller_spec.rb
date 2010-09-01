require 'spec_helper'

describe FirmwaresController do
  include AuthlogicSpecHelpers
  integrate_views

  before do
    login
    @fw = Factory.build :firmware, :id => 37
    @fwv = Factory.build :firmware_version, :number => 13, :firmware => @fw, :created_at => Time.now
    stub(@fw).version { @fwv }
  end

  %w{index all new}.each do |action|
    describe "##{action}" do
      it "should work" do
        get action
        response.should be_success
      end
    end
  end

  %w{show index_versions}.each do |action|
    describe "##{action}" do
      it "should work" do
        mock_find

        get action, :id => 37
        response.should be_success
      end
    end
  end

  describe '#create' do
    it "should create good firmware" do
      any_instance_of Firmware, :save => true, :id => 37

      post 'create'
      response.should be_redirect
    end

    it "should not create bad firmware" do
      any_instance_of Firmware, :save => false

      post 'create'
      response.should render_template 'new'
    end
  end

  describe '#edit' do
    it "should not work when not logged in" do
      logout

      get 'edit', :id => 37
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should not work when not owner" do
      mock_find
      mock(current_user).owns?(@fw) { false }

      get 'edit', :id => 37
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should work when logged in as owner" do
      mock_find
      mock(current_user).owns?(@fw) { true }

      get 'edit', :id => 37
      response.should be_success
    end
  end

  describe '#update' do
    before do
      mock_find
      mock(current_user).owns?(@fw) { true }
    end

    it "should save good update" do
      mock(@fw).save { true }

      put 'update', :id => '37'
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not save bad update" do
      mock(@fw).save { false }

      put 'update', :id => '37'
      response.should render_template 'edit'
    end
  end

  describe "code" do
    before { mock_find }

    it "should give code when request.xhr?" do
      stub(request).xhr? { true }

      get 'code', :id => '37'
      response.should be_success
    end

    it "should redirect to firmware path when not request.xhr?" do
      stub(request).xhr? { false }

      get 'code', :id => '37'
      response.should be_redirect
    end
  end

  describe "show_version" do
    it "should work" do
      mock_find
      mock(FirmwareVersion).find(:first, {:conditions => { :number => '42' }}) { @fwv }

      get 'show_version', :id => 37, :number => 42
    end
  end

  def mock_find
    mock(Firmware).find('37') { @fw }
  end
end
