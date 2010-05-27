require 'emulation_system_helper'

describe EmulationSystem::Emulation::Bot do
  before do
    @bot = build :bot
    def @bot.stack; instance_variable_get '@stack'; end
    def @bot.stack=(value); instance_variable_set '@stack', value; end
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
      @bot.step.should == 0
    end

    it "should return time spent on last step" do
      pending
      @bot.step.should == 37
    end
  end

  describe "#upper_block_from" do
    before do
      stub(@block1 = Object.new).is_a?(EmulationSystem::Emulation::RuntimeElements::Block) { true }
      stub(@block2 = Object.new).is_a?(EmulationSystem::Emulation::RuntimeElements::Block) { true }
      @bot.stack = [:foo, @block1, @block2, :other]
    end

    it "should return nil if we got the block not in the stack" do
      @bot.upper_block_from( :another ).should be_nil
    end

    it "should return nil if we got the uppest block" do
      @bot.upper_block_from( :foo ).should be_nil
    end

    it "should return upper block from element" do
      @bot.upper_block_from( :other ).should == @block2
    end

    it "should return upper block from other block" do
      @bot.upper_block_from( @block2 ).should == @block1
    end
  end

  describe "#push_element" do
    {
      'block' => EmulationSystem::Emulation::RuntimeElements::Block,
      '3' => EmulationSystem::Emulation::RuntimeElements::Number,
      '3.7' => EmulationSystem::Emulation::RuntimeElements::Number,
      '=' => EmulationSystem::Emulation::RuntimeElements::Assignment,
    }.each_pair do |data, klass|
      it "should push to stack element #{klass.name.split('::').last}" do
        # несколько детей, чтобы конструкторы элементов не падали
        @bot.push_element build(:node, data, [build(:node), build(:node)])
        @bot.stack.last.should be_a klass
      end
    end
  end
end
