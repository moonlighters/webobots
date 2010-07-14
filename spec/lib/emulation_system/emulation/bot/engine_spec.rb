require 'emulation_system_helper'

describe EmulationSystem::Emulation::Bot::Engine do
  before do
    @bot = build :bot
    @state = @bot.state
  end

  describe "#dead" do
    it "should return false if bot is alive" do
      @bot.should_not be_dead
    end

    it "should return true if bot is dead" do
      @bot.state.health = 0
      @bot.should be_dead
    end
  end

  describe "#calc_physics_for" do
    before do
      @dt = 0.0001
    end

    describe "moving" do
      it "should emulate bot that is not moving" do
        @state.speed = 0
        @state.desired_speed = 0
        lambda{ @bot.calc_physics_for @dt }.should_not change { @state }
      end

      it "should emulate uniform motion" do
        @state.desired_speed = @state.speed = 68.0
        @state.angle = 0
        x = @state.pos.x

        lambda do
          158.times { @bot.calc_physics_for @dt }
        end.should_not change { [@state.speed, @state.pos.y] }

        @state.pos.x.should be_approximately_equal_to(x + 158*@dt*@state.speed)
      end

      it "should emulate uniformly accelerated motion" do
        @state.speed = 0.0
        @state.desired_speed = 10.0
        @state.angle = -90
        y = @state.pos.y
        t = 0

        lambda do
          until @state.speed == @state.desired_speed
            @bot.calc_physics_for @dt
            t += @dt
          end
        end.should_not change { [@state.pos.x, @state.desired_speed] }

        t.should be_approximately_equal_to @state.desired_speed/World::ACCELERATION
        @state.pos.y.should be_approximately_equal_to y - World::ACCELERATION*t**2/2, 0.001
      end

      it "should emulate uniformly decelerated motion" do
        @state.speed = 10.0
        @state.desired_speed = 0.0
        @state.angle = 180
        x = @state.pos.x
        t = 0

        lambda do
          until @state.speed == 0
            @bot.calc_physics_for @dt
            t += @dt
          end
        end.should_not change { [@state.pos.y, @state.desired_speed] }

        t.should be_approximately_equal_to 10.0/World::DECELERATION
        @state.pos.x.should be_approximately_equal_to x - World::DECELERATION*t**2/2, 0.01
      end
    end

    describe "collisions" do
      before do
        @one = build :bot
        @two = build :bot
      end

      it "should prevent collision of two bots into each other" do
        # Пусть есть два бота, уже пересекающиеся друг с другом, и изо всех сил едущие навстречу друг другу
        @one.state.pos = Vector[500, 500]
        @two.state.pos = @one.state.pos + Vector[2*World::BOT_RADIUS, 0]
        @one.state.speed = @one.state.desired_speed = World::MAX_SPEED
        @two.state.speed = @two.state.desired_speed = World::MAX_SPEED
        @one.state.angle = 0
        @two.state.angle = 180

        100.times { @one.calc_physics_for @dt, [@two] }

        # Они не должны пересекаться, а должны стоять друг к другу в упор
        (@one.state.pos - @two.state.pos).abs.should be_approximately_equal_to 2*World::BOT_RADIUS
      end

      it "should detect collisions between bots even if their states are equal" do
        @two.state.pos = @one.state.pos

        100.times { @one.calc_physics_for @dt, [@two] }

        (@one.state.pos - @two.state.pos).abs.should be_approximately_equal_to 2*World::BOT_RADIUS
      end
    end
  end
end
