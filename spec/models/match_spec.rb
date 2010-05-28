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

  [:first, :second].each do |attr|
    it "should not create a new instance without '#{attr}'" do
      Factory.build(:match, attr => nil).should_not be_valid
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
end
