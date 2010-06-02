require 'emulation_system_helper'

describe EmulationSystem::Emulation::RTLib do
  describe "#call" do
    before do
      @rtlib = build :rtlib
    end

    it "should call some defined function" do
      mock(@rtlib).has_function?('foo') { true }
      mock(@rtlib).foo(37) { :blah }

      @rtlib.call( 'foo', 37 ).should == :blah
    end

    it "should not call undefined function" do
      mock(@rtlib).has_function?('foo') { false }

      lambda { @rtlib.call 'foo', 37 }.should raise_error
    end

    it "should not call function given invalid number of arguments" do
      mock(@rtlib).has_function?('foo') { true }
      mock(@rtlib).foo(37, 42) { raise ArgumentError, "wrong number of arguments (2 for 1)" }

      lambda { @rtlib.call 'foo', 37, 42 }.should raise_error EmulationSystem::Errors::WFLRuntimeError
    end
  end

  describe "function" do
    before do
      @bot1 = build :bot
      @bot1.state.pos.x = 300.0
      @bot1.state.pos.y = 400.0
      @bot1.state.angle = 45.0
      @bot1.state.speed = 30.0
      @bot1.state.desired_speed = 75.0
      @bot1.state.health = 90.0
      @bot1.time = 37

      @bot2 = build :bot
      @bot2.state.pos.x = 700.0
      @bot2.state.pos.y = 800.0
      @bot2.state.angle = 270.0
      @bot2.state.speed = 10.0
      @bot2.state.desired_speed = 95.0
      @bot2.state.health = 15.0
      @bot2.time = 38

      @rtlib = build :rtlib, @bot1, @bot2
    end

    describe "posx" do
      it "should return x coordinate of friendly bot" do
        @rtlib.call( 'posx' ).should == 300
      end
    end
    describe "posy" do
      it "should return y coordinate of friendly bot" do
        @rtlib.call( 'posy' ).should == 400
      end
    end
    describe "angle" do
      it "should return angle of friendly bot" do
        @rtlib.call( 'angle' ).should == 45
      end
    end
    describe "speed" do
      it "should return speed of friendly bot" do
        @rtlib.call( 'speed' ).should == 30
      end
    end
    describe "desired_speed" do
      it "should return desired speed of friendly bot" do
        @rtlib.call( 'desired_speed' ).should == 75
      end
    end
    describe "health" do
      it "should return health of friendly bot" do
        @rtlib.call( 'health' ).should == 90
      end
    end
    describe "time" do
      it "should return time of friendly bot" do
        @rtlib.call( 'time' ).should == 37
      end
    end
    describe "rotate" do
      it "should set angle if speed is not too great" do
        @bot1.state.speed = World::MAX_SPEED_WHEN_ROTATION_POSSIBLE/2
        @rtlib.call( 'rotate', 37 ).should == 1
        @bot1.state.angle.should == 37
      end
      it "should not set angle if speed is too great" do
        @bot1.state.speed = World::MAX_SPEED
        lambda { @rtlib.call( 'rotate', 37 ).should == 0 }.should_not change { @bot1.state.angle }
      end
    end
    describe "set_speed" do
      it "should set correct desired speed" do
        lambda { @rtlib.call( 'set_speed', 37 ).should == 1 }.should_not change { @bot1.state.speed }
        @bot1.state.desired_speed.should == 37
      end
      it "should correctly set desired speed given negative speed" do
        lambda { @rtlib.call( 'set_speed', -10 ).should == 0 }.should_not change { @bot1.state.speed }
        @bot1.state.desired_speed.should == 0
      end
      it "should correctly set desired speed given too great speed" do
        lambda { @rtlib.call( 'set_speed', World::MAX_SPEED+10 ).should == 0 }.should_not change { @bot1.state.speed }
        @bot1.state.desired_speed.should == World::MAX_SPEED
      end
    end
    describe "sleep" do
      it "should increment bot's time" do
        lambda { @rtlib.call( 'sleep', 37 ).should == 37 }.should change { @bot1.time }.by 37
      end
    end
    describe "enemy_posx" do
      it "should return x coordinate of enemy bot" do
        @rtlib.call( 'enemy_posx' ).should == 700
      end
    end
    describe "enemy_posy" do
      it "should return y coordinate of enemy bot" do
        @rtlib.call( 'enemy_posy' ).should == 800
      end
    end
    describe "fire" do
      it "should fire missile" do
        pending "get missile control system"
        @rtlib.call( 'fire', 45, 100 )
      end
    end
  end
end
