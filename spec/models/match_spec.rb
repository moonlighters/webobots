require 'spec_helper'
require RAILS_ROOT + '/lib/rating'

describe Match do
  it "should create a new instance given valid attributes (no params given, generate automatically)" do
    create_match
  end

  it "should create a new instance given valid attributes (given custom params)" do
    create_match :parameters => { :seed => 4,
                                  :first => {:x => 1, :y => 1, :angle => 225},
                                  :second => {:x => 0.1, :y => 0.1, :angle => 45}
                                 }
  end

  [:first_version, :second_version, :user].each do |attr|
    it "should not create a new instance without '#{attr}'" do
      m = build_match(attr => nil).should_not be_valid
    end
  end

  describe "parameters validation" do
    before do
      @params = {
        :first => {:x => 1, :y => 1, :angle => 225},
        :second => {:x => 0.1, :y => 0.1, :angle => 45},
        :seed => 4
      }
    end

    [:first, :second, :seed].each do |attr|
      it "should filter hashes without #{attr}" do
        @params.delete attr
        build_match(:parameters => @params).should_not be_valid
      end
    end

    [:x, :y, :angle].each do |attr|
      it "should filter hashes without (first|second)/x#{attr}" do
        @params[:first].delete attr
        build_match(:parameters => @params).should_not be_valid
      end
    end
  end

  describe "complicated validation" do
    before do
      @fw = Factory :firmware
      @fwv = @fw.versions.create
    end

    it "should not pass given a firmware version with syntax errors" do
      stub(@fwv).syntax_errors { %w[ a lot of errors ] }

      build_match(:first_version => @fwv).should_not be_valid
      build_match(:second_version => @fwv).should_not be_valid
    end

    it "should not pass given not user's versions" do
      build_match(:first_version => @fwv, :second_version => @fwv, :user => Factory(:user)).should_not be_valid
    end

    it "should not pass if version of opponent's firmware is not the last" do
      @fw.versions.create
      build_match(:first_version => @fw.versions.first).should_not be_valid
    end

    it "should pass if version of owned firmware is not the last" do
      @fw.versions.create
      build_match(:first_version => @fw.versions.first, :user => @fw.user).should be_valid
    end

    it "should not pass if opponent's firmware is not available" do
      @fw.update_attribute :available, false
      build_match(:first_version => @fwv).should_not be_valid
    end

    it "should pass if owned firmware is not available" do
      @fw.update_attribute :available, false
      build_match(:first_version => @fwv, :user => @fw.user).should be_valid
    end

  end

  describe "#emulate" do
    it "should set result and point values" do
      m = create_match
      logger = Object.new
      stub(logger).add_log_record
      mock(EmulationSystem).emulate(m.first_version.code,
                                    m.second_version.code,
                                    m.parameters,
                                    logger) { { :result => :second } }
      m.emulate(logger)
      m.result.should == :second
      m.first_points.should_not be_nil
      m.second_points.should_not be_nil
    end

    it "should set result and point values" do
      m = create_match
      logger = Object.new
      stub(logger).add_log_record
      mock(EmulationSystem).emulate(m.first_version.code,
                                    m.second_version.code,
                                    m.parameters,
                                    logger) { { :error => {:message => "failure", :bot => :second}} }
      m.emulate(logger)
      m.should be_failed
      m.rt_error_msg.should == "failure"
      m.rt_error_bot.should == :second
    end
  end

  describe "named scope" do
    describe "Match.all_for" do
      before do
        @fwv = Factory :firmware_version
        Factory :match
        @m1 = Factory :match, :first_version => @fwv
        Factory :match
        @m2 = Factory :match, :first_version => @fwv, :second_version => @fwv
        Factory :match
      end

      it "should return all matches for given user" do
        Match.all_for(@fwv.user).sort_by(&:id).should == [@m1, @m2].sort_by(&:id)
      end

      it "shoulc return all matches with given firmware" do
        Match.all_for(@fwv.firmware).sort_by(&:id).should == [@m1, @m2].sort_by(&:id)
      end
    end

    describe "(won, lost, tied)" do
      before do
        @fwv = Factory :firmware_version
        @m1 = Factory :match, :first_version => @fwv, :result => :first
        @m2 = Factory :match, :first_version => @fwv, :result => :draw
        @m3 = Factory :match, :first_version => @fwv, :result => :second
        @m4 = Factory :match, :second_version => @fwv, :result => :first
        @m5 = Factory :match, :second_version => @fwv, :result => :draw
        @m6 = Factory :match, :second_version => @fwv, :result => :second
      end

      it "Match.won_by should return all won matches for given user" do
        Match.won_by(@fwv.user).sort_by(&:id).should == [@m1, @m6].sort_by(&:id)
      end

      it "Match.lost_by should return all won matches for given user" do
        Match.lost_by(@fwv.user).sort_by(&:id).should == [@m3, @m4].sort_by(&:id)
      end

      it "Match.tied_by should return all won matches for given user" do
        Match.tied_by(@fwv.user).sort_by(&:id).should == [@m2, @m5].sort_by(&:id)
      end
    end
  end

  private

  # хаки поверх factory_girl
  def create_match(opts = {})
    fwv = Factory :firmware_version
    u = fwv.firmware.user
    Factory :match, opts.merge(:first_version => fwv, :user => u)
  end
  def build_match(opts = {})
    fwv = Factory.build :firmware_version
    u = fwv.firmware.user
    Factory.build :match, {:first_version => fwv, :user => u}.merge(opts)
  end
end
