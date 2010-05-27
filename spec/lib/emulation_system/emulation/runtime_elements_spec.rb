require 'emulation_system_helper'

describe EmulationSystem::Emulation::RuntimeElements do
  before do
    @bot = build :bot
  end

  describe "Block" do
    it "should be creatable" do
      RuntimeElements::Block.new @bot, build(:node, 'block')
    end

    describe "#run" do
      it "should push children to stack one by one and pop" do
        lambda do
          node1 = build :node
          node2 = build :node

          @bot.push_element build(:node, 'block', [ node1,node2 ])
          
          mock(@bot).push_element(node1)
          @bot.step.should be_a Fixnum
          
          mock(@bot).push_element(node2)
          @bot.step.should be_a Fixnum
          
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  describe "Assignment" do
    it "should be creatable" do
      RuntimeElements::Assignment.new @bot, build(:node, '=', [build(:node,'a')])
    end

    describe "#run" do
      it "should push expr to stack, assign result to upper block's variable and pop " do
        lambda do
          num37 = build :node, '37'
          @bot.push_element build(:node, '=', [ build(:node, 'foo'), num37 ])
          
          mock(@bot).push_element(num37)
          @bot.step.should be_a Fixnum

          mock(@bot).upper_block_from(anything) { mock!.variables { mock!.[]=('foo',37) } }
          mock(@bot).pop_var { 37 }
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  describe "Number" do
    it "should be creatable" do
      RuntimeElements::Number.new @bot, build(:node, '3.7')
    end

    describe "#run" do
      it "should push value from node and pop" do
        lambda do
          @bot.push_element build(:node, '3.7')

          mock(@bot).push_var 3.7
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  def Object.const_missing(c)
    EmulationSystem::Emulation.const_get(c)
  end
end
