require 'emulation_system_helper'

describe EmulationSystem::Emulation::Bot::State do
  before do
    @state = build(:bot).state
  end

  def assign(object, attribute, value)
    object.send("#{attribute}=".to_sym, value)
  end

  describe "#radians" do
    it "should return initial value" do
      @state = Bot::State.new Vector[1,2], 37
      @state.angle.should == 37
    end

    it "should get" do
      @state.angle = 45
      @state.radians.should == Math::PI/4
    end

    it "should assign" do
      @state.radians = 2*Math::PI/3
      @state.angle.should be_close 120, 1e-9
    end

    it "should get and assign" do
      # комплексный на #radians и #radians=
      @state.radians = 2.3
      @state.radians.should be_close 2.3, 1e-9
    end
  end

  describe "#cosa" do
    it "should return cosine" do
      @state.angle = 0
      @state.cosa.should be_close 1, 1e-9
    end
  end

  describe "#sina" do
    it "should return sine" do
      @state.angle = -90
      @state.sina.should be_close -1, 1e-9
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

  describe "#correct" do
    before do
      class << @state
        def posx; pos.x end
        def posy; pos.y end
        def posx=(x); self.pos.x = x end
        def posy=(y); self.pos.y = y end
      end
    end

    [
      {:attr => :speed, :min => 0, :max => World::MAX_SPEED},
      {:attr => :health, :min => 0, :max => World::MAX_HEALTH},
      {:attr => :posx, :min => World::BOT_RADIUS, :max => World::FIELD_SIZE - World::BOT_RADIUS},
      {:attr => :posy, :min => World::BOT_RADIUS, :max => World::FIELD_SIZE - World::BOT_RADIUS}
    ].each do |opts|
      describe "correction of attribute #{opts[:attr]}" do
        it "should correct if less than min" do
          assign(@state, opts[:attr], opts[:min] - 1)
          @state.correct
          @state.send(opts[:attr]).should == opts[:min]
        end

        it "should correct if greater than max" do
          assign(@state, opts[:attr], opts[:max] + 100500)
          @state.correct
          @state.send(opts[:attr]).should == opts[:max]
        end

        it "should not correct if inside interval" do
          good_val = (opts[:min] + opts[:max])/2
          assign(@state, opts[:attr], good_val)
          @state.correct
          @state.send(opts[:attr]).should == good_val
        end
      end
    end
  end
  
  [:speed, :desired_speed, :health].each do |attribute|
    describe "accessor ##{attribute}" do
      it "should work" do
        lambda do
          @state.send(attribute)
          assign(@state, attribute, 2.2)
        end.should_not raise_error
      end
    end
  end

  describe "accessor #pos" do
    it "should work" do
      lambda do
        @state.pos = V2D[1,1]
        @state.pos.should == V2D[1,1]
      end.should_not raise_error
    end
  end
end
