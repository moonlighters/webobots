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
      def should_add_missiles(n)
        raise unless block_given?
        lambda do
          yield
        end.should change { @rtlib.instance_variable_get('@vm').instance_variable_get('@missiles').count }.by n
      end

      it "should fire first missile" do
        should_add_missiles(1) { @rtlib.call('fire', 45, 100).should == 1 }
      end
      it "should not fire missile if already fired" do
        should_add_missiles(1) { @rtlib.call('fire', 45, 100) }
        should_add_missiles(0) { @rtlib.call('fire', 99, 10).should == 0 }
      end
      it "should fire missile after pause" do
        should_add_missiles(1) { @rtlib.call('fire', 45, 100) }
        should_add_missiles(0) { @rtlib.call('fire', 99, 10) }
        @bot1.time += 2/World::RATE_OF_FIRE
        should_add_missiles(1) { @rtlib.call('fire', 45, 100).should == 1 }
      end
    end
    describe "sin" do
      it "should return sin of angle" do
        @rtlib.call( 'sin', 30 ).should == Math.sin(Math::PI/6)
      end
    end
    describe "cos" do
      it "should return cos of angle" do
        @rtlib.call( 'cos', 60 ).should == Math.cos(Math::PI/3)
      end
    end
    describe "atan2" do
      it "should return arc tangent given y and x" do
        @rtlib.call( 'atan2', 2, 1).should == Math.atan2(2,1) * 180 / Math::PI
      end
    end
    describe "sqr" do
      it "should square argument" do
        @rtlib.call( 'sqr', 5 ).should == 25
      end
      it "should square negative argument" do
        @rtlib.call( 'sqr', -7 ).should == 49
      end
    end
    describe "sqrt" do
      it "should return square root of positive numeric" do
        @rtlib.call( 'sqrt', 25 ).should == 5
      end
      it "should raise given negative numeric" do
        lambda { @rtlib.call( 'sqrt', -49 ) }.should raise_error EmulationSystem::Errors::WFLRuntimeError
      end
    end
    describe "sqrt" do
      it "should return random number" do
        @rtlib.call( 'rand' ).should be_a Float
      end
    end
  end
end
