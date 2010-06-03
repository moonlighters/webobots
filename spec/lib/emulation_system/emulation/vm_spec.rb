require 'emulation_system_helper'

describe EmulationSystem::Emulation::VM do
  it "should be creatable and launchable" do
    res = build(:vm).emulate
    [:first, :second, :draw].should include res
  end
end
