require 'emulation_system_helper'

describe EmulationSystem::Emulation::Missile do
  before do
    @bot = build :bot
    @m = Missile.new @bot, 0, 100
  end

  it "should be creatable correctly" do
    @m.velocity.abs.should be_approximately_equal_to World::MISSILE_SPEED
    @m.should_not be_exploded
    @m.distance.should == 0
    @m.pos.should_not be_near_to @bot.state.pos, World::BOT_RADIUS
    @m.pos.should be_near_to @bot.state.pos, 2*World::BOT_RADIUS
  end

  describe "#explode!, #exploded?" do
    it "should work" do
      @m.explode!
      @m.should be_exploded
    end
  end

  describe "calc_physics_for" do
    before do
      @dt = 0.0001
    end

    it "should move" do
      x = @m.pos.x
      lambda do
        120.times { @m.calc_physics_for @dt }
      end.should_not change { @m.pos.y }
      @m.pos.x.should be_approximately_equal_to( x + World::MISSILE_SPEED*120*@dt )
    end

    it "should finally stop and explode" do
      @m = Missile.new @bot, Math::PI/2, 60
      y = @m.pos.y
      lambda do
        until @m.exploded?
          @m.calc_physics_for @dt
        end
      end.should_not change { @m.pos.x }
      @m.pos.y.should be_approximately_equal_to( y + @m.desired_distance, 0.1 )
    end

    it "should hit the border of battlefield" do
      @m = Missile.new @bot, Math::PI, 6000
      x = @m.pos.x
      lambda do
        until @m.exploded?
          @m.calc_physics_for @dt
        end
      end.should_not change { @m.pos.y }
      @m.pos.x.should be_approximately_equal_to 0, 0.05
    end
  end

  describe ".injure" do
    before do
      @m.pos = Vector[500, 500]
    end

    it "should not change bot's health if it is too far" do
      target = build_bot_at 1000, 500
      lambda do
        @m.injure target
      end.should_not change { target.state.health }
    end

    it "should change bot's health by MISSILE_DAMAGE if missile hits bot" do
      target = build_bot_at 500+World::BOT_RADIUS, 500
      lambda do
        @m.injure target
      end.should change { target.state.health }.by (-World::MISSILE_DAMAGE)
    end

    it "should change bot's health if missile is near bot" do
      target = build_bot_at 500+World::BOT_RADIUS+World::EXPLOSION_RADIUS/2, 500
      lambda do
        @m.injure target
      end.should change { target.state.health }
    end

    private
    def build_bot_at(x,y)
      build :bot, build(:ir), x, y
    end
  end
end
