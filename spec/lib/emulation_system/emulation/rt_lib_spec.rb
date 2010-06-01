require 'emulation_system_helper'

describe EmulationSystem::Emulation::RTLib do
  before do
    @rtlib = build :rtlib
  end

  describe "#call" do
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
end
