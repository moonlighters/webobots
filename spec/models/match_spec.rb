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
      5.times { @fw.versions.create }
      build_match(:first_version => @fw.versions.first).should_not be_valid
    end

    it "should pass if version of owned firmware is not the last" do
      5.times { @fw.versions.create }
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
                                    logger) { :second }
      m.emulate(logger).should == :second
      m.first_points.should_not be_nil
      m.second_points.should_not be_nil
    end
  end

  describe "named scope" do
    before do
      @fwv = Factory :firmware_version
      4.times { Factory :match }
      @m1 = Factory :match, :first_version => @fwv
      1.times { Factory :match }
      @m2 = Factory :match, :first_version => @fwv, :second_version => @fwv
      3.times { Factory :match }
    end

    describe "Match.all_for" do
      it "should return all matches for given user" do
        Match.all_for(@fwv.firmware.user).sort_by(&:id).should == [@m1, @m2].sort_by(&:id)
      end

      it "shoulc return all matches with given firmware" do
        Match.all_for(@fwv.firmware).sort_by(&:id).should == [@m1, @m2].sort_by(&:id)
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
