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

  describe "functions" do
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
  end
end
