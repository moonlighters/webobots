require 'spec_helper'

describe FirmwaresController do
  include AuthlogicSpecHelpers
  integrate_views

  before do
    login
    @fw = stub(Factory :firmware).id { 37 }.subject
    @fwv = Factory :firmware_version
    stub(@fw).version { @fwv }
    stub(@fwv).firmware { @fw }
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
        stub(Firmware).find.with_any_args { |*args| @fw }

        get action, :id => 37
        response.should be_success
      end
    end
  end

  describe '#create' do
    it "should create good firmware" do
      any_instance_of Firmware, :valid? => true

      lambda{ post 'create', :firmware => {} }.should change { FirmwareVersion.count }.by 1
      response.should be_redirect
    end

    it "should not create bad firmware" do
      any_instance_of Firmware, :valid? => false

      lambda{ post 'create', :firmware => {} }.should_not change { FirmwareVersion.count }
      response.should render_template 'new'
    end
  end

  describe '#edit' do
    it "should not work when not logged in" do
      stub(Firmware).find('37') { @fw }
      logout

      get 'edit', :id => 37
      response.should be_redirect
      flash[:alert].should_not be_nil
    end

    it "should not work when not owner" do
      mock(Firmware).find('37') { @fw }
      mock(current_user).owns?(@fw) { false }

      get 'edit', :id => 37
      response.should be_redirect
      flash[:alert].should_not be_nil
    end
    
    it "should work whtn logged in as owner" do
      mock(Firmware).find('37') { @fw }
      mock(current_user).owns?(@fw) { true }

      get 'edit', :id => 37
      response.should be_success
    end
  end

  describe '#update' do
    before { mock(current_user).owns?(@fw) { true } }

    it "should save good update" do
      stub(Firmware).find.with_any_args { |*args| @fw }
      # тут проще повесить mock на save, а не valid? из-за :autosave => true
      mock(@fw).save { true }
      
      put 'update', :id => '37', :firmware => { :firmware_version => {} }
      response.should be_redirect
      flash[:notice].should_not be_nil
    end

    it "should not save bad update" do
      mock(Firmware).find('37') { @fw }
      # тут проще повесить mock на save, а не valid? из-за :autosave => true
      mock(@fw).save { false }

      put 'update', :id => '37', :firmware => { :firmware_version => {} }
      response.should render_template 'edit'
    end
  end

  describe "code" do
    it "should give code when request.xhr?" do
      mock(Firmware).find('37') { @fw }
      stub(request).xhr? { true }

      get 'code', :id => '37'
      response.should be_success
    end

    it "should redirect to firmware path when not request.xhr?" do
      mock(Firmware).find('37') { @fw }
      stub(request).xhr? { false }

      get 'code', :id => '37'
      response.should be_redirect
    end
  end

  describe "show_version" do
    it "should work" do
        mock(Firmware).find('37') { @fw }
        stub(@fw).versions { mock([@fwv]).find_by_number!('11') { @fwv }.subject }

        get 'show_version', :id => 37, :number => 11
    end
  end
end
