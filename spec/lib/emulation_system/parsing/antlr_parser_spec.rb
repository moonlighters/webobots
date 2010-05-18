require 'emulation_system_helper'

describe EmulationSystem::Parsing::ANTLRParser do
  it "should be callable" do
    call("").should == "BLOCK"
  end

  private
  def call(code)
    EmulationSystem::Parsing::ANTLRParser.call code
  end
end
