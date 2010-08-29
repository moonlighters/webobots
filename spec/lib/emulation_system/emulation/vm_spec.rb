require 'emulation_system_helper'

describe EmulationSystem::Emulation::VM do
  it "should be creatable and launchable" do
    res = build(:vm).emulate 1.second
    [:first, :second, :draw].should include res
  end
end
