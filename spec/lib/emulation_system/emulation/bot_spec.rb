require 'emulation_system_helper'

describe EmulationSystem::Emulation::Bot do
  before do
    @bot = build :bot
  end

  it "should be creatable" do
    build :bot
  end

  describe "#halted?" do
    it "should return false if there is smth to eval" do
      @bot.should_not be_halted
    end

    it "should return true if there is nothing to eval" do
      @bot.stack = []
      @bot.should be_halted
    end

    it "should return true if bot is dead" do
      @bot.state.health = 0
      @bot.should be_halted
    end
  end
  
  describe "#dead" do
    it "should return false if bot is alive" do
      @bot.should_not be_dead
    end

    it "should return true if bot is dead" do
      @bot.state.health = 0
    end
  end

  describe "#step" do
    it "should raise internal error if nothing to run" do
      @bot.stack = []
      lambda { @bot.step }.should raise_error
    end

    it "should raise internal error if bot already dead" do
      @bot.state.health = 0
      lambda { @bot.step }.should raise_error
    end

    it "should return time spent on last step" do
      mock(elem = Object.new).run { 37 }
      @bot.stack << elem
      @bot.step.should == 37
    end
  end

  describe "#log" do
    it "should call given log_func" do
      mock(func = Object.new).call "foo blah"
      bot = EmulationSystem::Emulation::Bot.new build(:ir), 1,2,3, func
      bot.log "foo blah"
    end
  end

  describe "#upper_block_from" do
    before do
      stub(@block1 = Object.new).function? { false }
      stub(@block2 = Object.new).function? { false }
      stub(@blockF = Object.new).function? { true }
      stub(@block1).is_a?(RuntimeElements::Block) { true }
      stub(@block2).is_a?(RuntimeElements::Block) { true }
      stub(@blockF).is_a?(RuntimeElements::Block) { true }

      @bot.stack = [@block1, @blockF, @block2, :foo]
    end

    it "should return lowest block if we got the block not in the stack" do
      @bot.upper_block_from( :blah ).should == @block2
    end

    it "should return nil if we got the uppest block" do
      @bot.upper_block_from( @block1 ).should be_nil
    end

    it "should return upper block from element" do
      @bot.upper_block_from( :foo ).should == @block2
    end

    it "should return upper function block from element" do
      @bot.upper_block_from( :foo, :function => true ).should == @blockF
    end

    it "should return global block" do
      @bot.upper_block_from( :foo, :global => true ).should == @block1
    end

    it "should return upper block from other block" do
      @bot.upper_block_from( @blockF ).should == @block1
    end
  end

  describe "#(push|pop)_var" do
    it "should push variable to bot's special stack and then pop it" do
      bot = build :bot
      bot.pop_var.should be_nil
      bot.push_var 37
      bot.pop_var.should == 37
      bot.pop_var.should be_nil
    end
  end

  describe "#push_element" do
    {
      'block' => RuntimeElements::Block,
      '3' => RuntimeElements::Literal,
      '3.7' => RuntimeElements::Literal,
      '"str"' => RuntimeElements::Literal,
      '=' => RuntimeElements::Assignment,
      'if' => RuntimeElements::If,
      'while' => RuntimeElements::While,
      'var' => RuntimeElements::Variable,
      '+' => RuntimeElements::BinaryOp,
      '-' => RuntimeElements::BinaryOp,
      '*' => RuntimeElements::BinaryOp,
      '/' => RuntimeElements::BinaryOp,
      '>' => RuntimeElements::BinaryOp,
      '<' => RuntimeElements::BinaryOp,
      '>=' => RuntimeElements::BinaryOp,
      '<=' => RuntimeElements::BinaryOp,
      '==' => RuntimeElements::BinaryOp,
      '!=' => RuntimeElements::BinaryOp,
      'and' => RuntimeElements::BinaryOp,
      'or' => RuntimeElements::BinaryOp,
      'uplus' => RuntimeElements::UnaryOp,
      'uminus' => RuntimeElements::UnaryOp,
      'not' => RuntimeElements::UnaryOp,
      'funcdef' => RuntimeElements::FuncDef,
      'funccall' => RuntimeElements::FuncCall,
      'return' => RuntimeElements::Return,
      'log' => RuntimeElements::Log,
    }.each_pair do |data, klass|
      it "should push to stack element #{klass.name.split('::').last}" do
        # несколько детей, чтобы конструкторы элементов не падали
        @bot.push_element build(:node, data, [])
        @bot.stack.last.should be_a klass
      end
    end

    it "should push to stack element with extra arguments" do
      node = build(:node, 'block')
      mock(RuntimeElements::Block).new(is_a(Bot), node, :arg1, :arg2)
      @bot.push_element node, :arg1, :arg2
    end
  end
  
  describe EmulationSystem::Emulation::Bot::State do
    before do
      @state = @bot.state
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
    
    describe "#calc_physics_for" do
      before do
        @dt = 0.0001
        @other_bots = [build(:bot, nil, 1.1*World::BOT_RADIUS, 1.1*World::BOT_RADIUS)]
      end

      it "should emulate bot that is not moving" do
        @state.speed = 0
        @state.desired_speed = 0
        lambda{ @state.calc_physics_for @dt, @other_bots }.should_not change { @state }
      end

      it "should emulate uniform motion" do
        @state.desired_speed = @state.speed = 68.0
        @state.angle = 0
        x = @state.pos.x

        lambda do
          158.times { @state.calc_physics_for @dt, @other_bots }
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
            @state.calc_physics_for @dt, @other_bots
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
            @state.calc_physics_for @dt, @other_bots
            t += @dt
          end
        end.should_not change { [@state.pos.y, @state.desired_speed] }

        t.should be_approximately_equal_to 10.0/World::DECELERATION
        @state.pos.x.should be_approximately_equal_to x - World::DECELERATION*t**2/2, 0.01
      end

      it "should detect collisions between bots" do
        # Пусть есть два бота, уже пересекающиеся друг с другом, и изо всех сил едущие навстречу друг другу
        a = Math::PI/3 # угол отрезка соединяющего их центры
        d = Vector[Math::cos(a), Math::sin(a)] # направление от нас к противнику
        @other_bots.first.state.pos = @state.pos + d*World::BOT_RADIUS
        @other_bots.first.state.speed = @state.speed = World::MAX_SPEED
        @state.radians = a
        @other_bots.first.state.radians = -a

        10.times { @state.calc_physics_for @dt, @other_bots }

        # Они не должны пересекаться, а должны стоять друг к другу в упор
        (@state.pos - @other_bots.first.state.pos).abs.should be_approximately_equal_to 2*World::BOT_RADIUS
      end

      it "should detect collisions between bots even if their states are equal" do
        @other_bots.first.state.pos = @state.pos
        @other_bots.first.state.speed = @state.speed
        @other_bots.first.state.desired_speed = @state.desired_speed
        
        10.times { @state.calc_physics_for @dt, @other_bots }

        (@state.pos - @other_bots.first.state.pos).abs.should be_approximately_equal_to 2*World::BOT_RADIUS
      end
    end
  end
end
