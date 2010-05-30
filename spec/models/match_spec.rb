require 'spec_helper'

describe Match do
  it "should create a new instance given valid attributes (no params given, generate automatically)" do
    Factory :match
  end
  
  it "should create a new instance given valid attributes (given custom patams)" do
    Factory :match, :parameters => { :seed => 4,
                                     :first => {:x => 1, :y => 1, :angle => 225},
                                     :second => {:x => 0.1, :y => 0.1, :angle => 45}
                                   }
  end

  [:first_version, :second_version].each do |attr|
    it "should not create a new instance without '#{attr}'" do
      m = Factory.build(:match, attr => nil).should_not be_valid
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
        Factory.build(:match, :parameters => @params).should_not be_valid
      end
    end
    
    [:x, :y, :angle].each do |attr|
      it "should filter hashes without (first|second)/x#{attr}" do
        @params[:first].delete attr
        Factory.build(:match, :parameters => @params).should_not be_valid
      end
    end
  end

  it "should not create a new instance given a firmware version with syntax errors" do
    fwv = Factory :firmware_version
    stub(fwv).syntax_errors { %w[ a lot of errors ] }

    Factory.build(:match, :first_version => fwv).should_not be_valid
    Factory.build(:match, :second_version => fwv).should_not be_valid
  end

  it "should create a new instance given user and not user's versions" do
    fwv = Factory :firmware_version
    not_owner = Factory :user
    Factory :match, :first_version => fwv, :second_version => fwv, :user => not_owner
  end
end
