require 'emulation_system_helper'

describe EmulationSystem::Emulation::RuntimeElements do
  before do
    @bot = build :bot
  end

  describe EmulationSystem::Emulation::RuntimeElements::Block do
    it "should be creatable as anonymous block" do
      block = RuntimeElements::Block.new @bot, build(:node, 'block')
      block.should_not be_function
    end

    it "should be creatable as function body" do
      block = RuntimeElements::Block.new @bot, build(:node, 'block'),
        :function => true, :params => {'foo' => 37, :blah => '42'}
      block.should be_function
      block.get_variable('foo').should == 37
    end

    it "should correctly get upper block" do
      # комплексный на
      # Block#new, Bot#push_element, Bot#upper_block_for
      @bot.push_element build(:node, 'block')
      upper = @bot.stack.last
      @bot.push_element build(:node, 'block')
      block = @bot.stack.last
      block.instance_variable_get( '@upper_block' ).should == upper
      block.should_not be_global
    end

    describe "#run" do
      it "should pop if there are no children" do
        lambda do
          @bot.push_element build(:node, 'block', [])
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end

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

    describe "#(set|get)_variable" do
      it "should return value of known identifier" do
        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        block.set_variable 'foo', 37
        block.get_variable('foo').should == 37
      end

      it "should ask upper block if could not find identifier" do
        mock(upper = Object.new).get_variable('blah') { 42 }
        mock(@bot).upper_block_from(anything) { upper }

        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        block.get_variable('blah').should == 42
      end

      it "should raise runtime error if could not find identifier and it is global block" do
        mock(@bot).upper_block_from(anything) { nil }
        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        lambda { block.get_variable 'unknown' }.should raise_error EmulationSystem::Errors::WFLRuntimeError
      end
    end

    describe "#(set|get)_function" do
      it "should not get unknown function" do
        mock(@bot).upper_block_from(anything) { nil }
        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        block.set_function 'foo', ['a','b'], build(:node)
        lambda do
          block.get_function('blah')
        end.should raise_error EmulationSystem::Errors::WFLRuntimeError
      end

      it "should set function for global block" do
        mock(@bot).upper_block_from(anything) { nil }
        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        block.set_function 'foo', ['a','b'], build(:node)
        block.get_function('foo').should be_a RuntimeElements::Block::Func
      end

      it "should get functions from lower blocks" do
        mock(@bot).upper_block_from(anything) { mock!.get_function('foo') { :func } }
        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        block.get_function('foo').should == :func
      end

      it "should not set function for not global block" do
        mock(@bot).upper_block_from(anything) { :upper_block }
        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        lambda do
          block.set_function 'foo', ['a','b'], build(:node)
        end.should raise_error EmulationSystem::Errors::WFLRuntimeError
      end

      it "should not set function if function with same name already defined" do
        mock(@bot).upper_block_from(anything) { nil }
        block = RuntimeElements::Block.new @bot, build(:node, 'block')
        block.set_function 'foo', ['a','b'], build(:node)
        lambda do
          block.set_function 'foo', ['c'], build(:node)
        end.should raise_error EmulationSystem::Errors::WFLRuntimeError
      end
    end

    describe EmulationSystem::Emulation::RuntimeElements::Block::Func do
      describe "#variables_hash_for" do
        before do
          @f = RuntimeElements::Block::Func.new 'foo', ['a','b'], build(:node)
        end

        it "should return right hash" do
          @f.variables_hash_for([1,2]).should == {
            'a' => 1,
            'b' => 2
          }
        end

        it "should raise error if wrong parameters number given" do
          lambda { @f.variables_hash_for [3] }.should raise_error EmulationSystem::Errors::WFLRuntimeError
        end
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::Assignment do
    it "should be creatable" do
      RuntimeElements::Assignment.new @bot, build(:node, '=', [build(:node,'a')])
    end

    describe "#run" do
      it "should push expr to stack, assign result to upper block's variable and pop " do
        lambda do
          expr = build :node
          @bot.push_element build(:node, '=', [ build(:node, 'foo'), expr ])
          
          mock(@bot).push_element(expr)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 37 }
          mock(@bot).upper_block_from(anything) { mock!.set_variable('foo',37) }
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::Number do
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

  describe EmulationSystem::Emulation::RuntimeElements::If do
    it "should be creatable" do
      RuntimeElements::If.new @bot, build(:node, 'if')
    end

    describe "#run" do
      it "should push expr to stack, then pop and push if_block if expr != 0" do
        lambda do
          expr = build :node
          if_block = build :node
          @bot.push_element build(:node, 'if', [expr, if_block])

          mock(@bot).push_element(expr)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 37 }
          mock(@bot).push_element(if_block)
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end

      it "should push expr to stack, then pop if expr == 0" do
        lambda do
          expr = build :node
          @bot.push_element build(:node, 'if', [expr, build(:node)])

          mock(@bot).push_element(expr)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 0 }
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end

      it "should push expr to stack, then pop and push else_block if expr == 0" do
        lambda do
          expr = build :node
          else_block = build :node
          @bot.push_element build(:node, 'if', [expr, build(:node), else_block])

          mock(@bot).push_element(expr)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 0 }
          mock(@bot).push_element(else_block)
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::Variable do
    it "should be creatable" do
      RuntimeElements::Variable.new @bot, build(:node, 'var', [build(:node,'foo')])
    end

    describe "#run" do
      it "should push identifiers value and pop" do
        lambda do
          @bot.push_element build(:node, 'var', [build(:node, 'foo')])

          mock(@bot).upper_block_from(anything) { mock!.get_variable('foo') { 37 } }
          mock(@bot).push_var(37)
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::BinaryOp do
    it "should be creatable" do
      RuntimeElements::BinaryOp.new @bot, build(:node, '+')
    end

    describe "#run" do
      %w{ + - * }.each do |op|
        it "should push left and right expr to stack, then pop and push (left#{op}right) if '#{op}'" do
          lambda do
            exprL = build :node
            exprR = build :node
            @bot.push_element build(:node, op, [exprL, exprR])

            mock(@bot).push_element(exprL)
            @bot.step.should be_a Fixnum

            mock(@bot).pop_var { 37 }
            mock(@bot).push_element(exprR)
            @bot.step.should be_a Fixnum

            mock(@bot).pop_var { 42 }
            mock(@bot).push_var( eval "37#{op}42" )
            @bot.step.should be_a Fixnum
          end.should_not change { @bot.stack.size }
        end
      end

      it "should push left and right expr to stack, then raise if '/' and right expr is 0" do
        lambda do
          exprL = build :node
          exprR = build :node
          @bot.push_element build(:node, '/', [exprL, exprR])

          mock(@bot).push_element(exprL)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 37 }
          mock(@bot).push_element(exprR)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 0 }
          @bot.step
        end.should raise_error EmulationSystem::Errors::WFLRuntimeError
      end

      %w{ > >= < <= != == }.each do |op|
        [[37,42],[42,37],[6,6]].each do |l,r|
          it "should push left(#{l}) and right(#{r}) expr to stack, then pop and push (#{l}#{op}#{r}) as int if '#{op}'" do
            lambda do
              exprL = build :node
              exprR = build :node
              @bot.push_element build(:node, op, [exprL, exprR])

              mock(@bot).push_element(exprL)
              @bot.step.should be_a Fixnum

              mock(@bot).pop_var { l }
              mock(@bot).push_element(exprR)
              @bot.step.should be_a Fixnum

              mock(@bot).pop_var { r }
              mock(@bot).push_var( eval( "#{l}#{op}#{r}" ) ? 1 : 0 )
              @bot.step.should be_a Fixnum
            end.should_not change { @bot.stack.size }
          end
        end
      end

      %w{ and or }.each do |op|
        [[37,42],[37,0],[0,0]].each do |l,r|
          it "should push left(#{l}) and right(#{r}) expr to stack, then pop and push (#{l}#{op}#{r}) as int if '#{op}'" do
            lambda do
              exprL = build :node
              exprR = build :node
              @bot.push_element build(:node, op, [exprL, exprR])

              mock(@bot).push_element(exprL)
              @bot.step.should be_a Fixnum

              mock(@bot).pop_var { l }
              mock(@bot).push_element(exprR)
              @bot.step.should be_a Fixnum

              mock(@bot).pop_var { r }
              mock(@bot).push_var( eval( "#{l != 0} #{op} #{r != 0}" ) ? 1 : 0 )
              @bot.step.should be_a Fixnum
            end.should_not change { @bot.stack.size }
          end
        end
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::UnaryOp do
    it "should be creatable" do
      RuntimeElements::UnaryOp.new @bot, build(:node, 'not')
    end

    describe "#run" do
      it "should push expr to stack, then pop and push expr if 'uplus'" do
        lambda do
          expr = build :node
          @bot.push_element build(:node, 'uplus', [expr])

          mock(@bot).push_element(expr)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 37 }
          mock(@bot).push_var( 37 )
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end

      it "should push expr to stack, then pop and push (-expr) if 'uminus'" do
        lambda do
          expr = build :node
          @bot.push_element build(:node, 'uminus', [expr])

          mock(@bot).push_element(expr)
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 37 }
          mock(@bot).push_var( -37 )
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end

      [6, 0].each do |value|
        it "should push expr(#{value}) to stack, then pop and push (not (#{value} as bool)) as int if 'not'" do
          lambda do
            expr = build :node
            @bot.push_element build(:node, 'not', [expr])

            mock(@bot).push_element(expr)
            @bot.step.should be_a Fixnum

            mock(@bot).pop_var { value }
            mock(@bot).push_var( value!=0 ? 0 : 1 )
            @bot.step.should be_a Fixnum
          end.should_not change { @bot.stack.size }
        end
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::FuncDef do
    it "should be creatable" do
      RuntimeElements::FuncDef.new @bot, build(:node, 'funcdef', [])
    end

    describe "#run" do
      it "should call set_function from upper block and pop" do
        lambda do
          block = build(:node, 'block')
          @bot.push_element build(:node, 'funcdef',
            [ build(:node, 'foo'), build(:node, 'params', [build(:node,'a'),build(:node,'b')]), block ])
          
          mock(@bot).upper_block_from(anything) { mock!.set_function('foo', ['a','b'], block) }
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::FuncCall do
    it "should be creatable" do
      RuntimeElements::FuncCall.new @bot, build(:node, 'funccall', [])
    end

    describe "#run" do
      it "should eval all params, get function from upper block, pop and push block with params" do
        lambda do
          p1 = build(:node, 'block')
          p2 = build(:node, 'block')
          func = Object.new
          mock(func).variables_hash_for([37,42]) { :func_vars_hash }
          mock(func).block { :func_block }
          mock(@bot).upper_block_from(anything) { mock!.get_function('foo') { func } }
          @bot.push_element build(:node, 'funccall',
            [ build(:node, 'foo'), build(:node, 'params', [p1,p2]) ])
          
          mock(@bot).push_element p1 
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 37 }
          mock(@bot).push_element p2
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 42 }
          mock(@bot).push_element( :func_block, :function => true, :params => :func_vars_hash )
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end

  describe EmulationSystem::Emulation::RuntimeElements::Return do
    it "should be creatable" do
      RuntimeElements::Return.new @bot, build(:node, 'return', [])
    end

    describe "#run" do
      it "should clean stack including last function block if no expr given" do
        lambda do
          @bot.push_element build(:node, 'block'), :function => true
          @bot.push_element build(:node, 'if')
          @bot.push_element build(:node, 'block')
          @bot.push_element build(:node, 'return')

          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
      
      it "should clean stack including last function block and push expr if expr given" do
        lambda do
          @bot.push_element build(:node, 'block'), :function => true
          @bot.push_element build(:node, 'if')
          @bot.push_element build(:node, 'block')
          expr = build(:node)
          @bot.push_element build(:node, 'return', [expr])

          mock(@bot).push_element expr
          @bot.step.should be_a Fixnum

          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
      
      it "should raise error if there are no upper function block" do
        lambda do
          @bot.push_element build(:node, 'block')
          @bot.push_element build(:node, 'if')
          @bot.push_element build(:node, 'block')
          @bot.push_element build(:node, 'return')

          @bot.step.should be_a Fixnum
        end.should raise_error EmulationSystem::Errors::WFLRuntimeError
      end
    end
  end
   
  describe EmulationSystem::Emulation::RuntimeElements::Log do
    it "should be creatable" do
      RuntimeElements::Log.new @bot, build(:node, 'log', [])
    end

    describe "#run" do
      it "should eval all log items, make string and give it to bot" do
        lambda do
          p1 = build(:node, 'block')
          p2 = build(:node, 'block')
          @bot.push_element build(:node, 'log', [p1,p2])
          
          mock(@bot).push_element p1 
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { "foo" }
          mock(@bot).push_element p2
          @bot.step.should be_a Fixnum

          mock(@bot).pop_var { 37 }
          mock(@bot).log("foo 37")
          @bot.step.should be_a Fixnum
        end.should_not change { @bot.stack.size }
      end
    end
  end
end
