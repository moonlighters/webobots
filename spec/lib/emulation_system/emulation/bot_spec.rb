require 'emulation_system_helper'

describe EmulationSystem::Emulation::Bot do
  before do
    @bot = build :bot
  end

  it "should be creatable" do
    build :bot
  end

  describe "#halted?" do
    it "should return true if there are smth to eval" do
      @bot.should_not be_halted
    end

    it "should return false if there is nothing to eval" do
      @bot.stack = []
      @bot.should be_halted
    end
  end

  describe "#step" do
    it "should return 0 if nothing to run" do
      @bot.stack = []
      @bot.step.should be_nil
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
      @bot.upper_block_from( :foo, true ).should == @blockF
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
end
