require 'emulation_system_helper'

describe EmulationSystem::Emulation::Bot::State do
  before do
    @state = build(:bot).state
  end

  describe "#radians" do
    it "should get" do
      @state.angle = 45
      @state.radians.should == Math::PI/4
    end

    it "should assign" do
      @state.radians = 2*Math::PI/3
      @state.angle.should == 120
    end

    it "should get and assign" do
      # комплексный на #radians и #radians=
      @state.radians = 2.3
      @state.radians.should == 2.3
    end
  end

  describe "#speed_mode" do
    before do
      @state.desired_speed = 50
    end

    it "should be accelerated if speed is less than desired speed" do
      @state.speed = @state.desired_speed - 1
      @state.speed_mode.should == :accelerated
    end

    it "should be accelerated if speed is less than desired speed" do
      @state.speed = @state.desired_speed + 1
      @state.speed_mode.should == :decelerated
    end

    it "should be accelerated if speed is less than desired speed" do
      @state.speed = @state.desired_speed
      @state.speed_mode.should == :uniform
    end
  end

  describe "#correct_value" do
    it "should correct if less than min" do
      @state.correct_value(2, 3, 4).should == 3
    end
    it "should correct if greater than max" do
      @state.correct_value(5, 3, 4).should == 4
    end
    it "should not correct if inside interval" do
      @state.correct_value(3.754, 3, 4).should == 3.754
    end
  end

end
