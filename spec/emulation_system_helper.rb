require 'spec_helper'

# Include all EmulationSystem
Dir[File.expand_path(File.join(File.dirname(__FILE__),'..','lib','emulation_system','**','*.rb'))].each {|f| require f}

def build(what, *args)
  case what
  when :node
    EmulationSystem::IR::Node.new( args[0] || 'block', args[1] || [] ) 
  when :ir
    EmulationSystem::IR.new( args[0] || build(:node) )
  when :bot
    EmulationSystem::Emulation::Bot.new(args[0] || build(:ir), 1, 2, 3)
  end
end

def Object.const_missing(c)
  EmulationSystem::Emulation.const_get(c)
end
