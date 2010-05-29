require 'spec_helper'

describe Match do
  it "should create a new instance given valid attributes (no params given, generate automatically)" do
    Factory.create :match
  end
  
  it "should create a new instance given valid attributes (given custom patams)" do
    Factory.create :match, :parameters => { :seed => 4,
                                            :first => {:x => 1, :y => 1, :angle => 225},
                                            :second => {:x => 0.1, :y => 0.1, :angle => 45}
                                          }
  end

  [:enemy, :friendly, :enemy_version, :friendly_version].each do |attr|
    it "should not create a new instance without '#{attr}'" do
      m = Factory.build(:match)
      m.update_attributes( attr => nil)
      m.should_not be_valid
    end
  end

  describe "should not create a new instance given invalid params: " do
    it "first-level" do
      Factory.build(:match, :parameters => {:first => {:x => 1, :y => 1, :angle => 225},
                                            :second => {:x => 0.1, :y => 0.1, :angle => 45}
                                           }).should_not be_valid
      Factory.build(:match, :parameters => {:seed => 4,
                                            :second => {:x => 0.1, :y => 0.1, :angle => 45}
                                           }).should_not be_valid
      Factory.build(:match, :parameters => {:seed => 4,
                                            :first => {:x => 1, :y => 1, :angle => 225},
                                           }).should_not be_valid
    end
    it "second-level" do
      Factory.build(:match, :parameters => {:seed => 4,
                                            :first => {:x => 1, :y => 1, :angle => 225},
                                            :second => {:y => 0.1, :angle => 45}
                                           }).should_not be_valid
      Factory.build(:match, :parameters => {:seed => 4,
                                            :first => {:x => 1, :angle => 225},
                                            :second => {:x => 0.1, :y => 0.1, :angle => 45}
                                           }).should_not be_valid
      Factory.build(:match, :parameters => {:seed => 4,
                                            :first => {:x => 1, :y => 1, :angle => 225},
                                            :second => {:x => 0.1, :y => 0.1}
                                           }).should_not be_valid
    end
  end
  it "should not create a new instance given a firmware with syntax errors" do
    fw = Factory.create :firmware
    fwv = Factory.create :firmware_version, :code => "a=", :firmware => fw

    f = Factory.build(:match, :enemy => fwv.firmware)
    f.enemy = fwv.firmware
    f.should_not be_valid
  end

  it "should not create a new instance given a firmware version with syntax errors" do
    fwv = Factory.create :firmware_version, :code => "a="

    Factory.build(:match, :enemy_version => fwv).should_not be_valid
    Factory.build(:match, :friendly_version => fwv).should_not be_valid
  end
end
