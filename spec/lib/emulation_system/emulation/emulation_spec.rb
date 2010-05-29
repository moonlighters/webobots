require 'emulation_system_helper'

describe EmulationSystem::Emulation::VM do
  it "should be creatable" do
    EmulationSystem::Emulation::VM.new(build(:ir), build(:ir), 
      { :first => {:x => 0.1, :y => 0.2, :angle => 0.3},
        :second => {:x=>0.4,:y=>0.5,:angle=>0.6},
        :seed => 4},
      :logger
    )
  end
end
