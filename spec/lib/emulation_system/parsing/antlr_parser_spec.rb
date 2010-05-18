require 'emulation_system_helper'

describe EmulationSystem::Parsing::ANTLRParser do
  it "should be callable" do
    EmulationSystem::Parsing::ANTLRParser.call ""
  end
end
