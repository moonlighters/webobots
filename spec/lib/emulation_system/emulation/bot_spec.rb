require 'emulation_system_helper'

describe EmulationSystem::Emulation::Bot do
  it "should be creatable" do
    build :bot
  end

  it "should include Engine and Processor" do
    Bot.should include Bot::Engine
    Bot.should include Bot::Processor
  end
end
