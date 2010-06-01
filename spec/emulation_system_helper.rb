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
    EmulationSystem::Emulation::Bot.new(args[0] || build(:ir), World::FIELD_SIZE/2, World::FIELD_SIZE/2, 3, :log_func)
  when :vm
    stub(logger = Object.new).add_frame(anything, anything, anything)
    stub(logger).add_log_record(anything, anything)
    EmulationSystem::Emulation::VM.new(
      args[0] || build(:ir), args[1] || build(:ir),
      {:first=>{:x=>1,:y=>1,:angle=>1},:second=>{:x=>2,:y=>2,:angle=>2},:seed=>3},
      logger)

  when :rtlib
    EmulationSystem::Emulation::RTLib.new(
      :for => args[0] || build(:bot), :against => args[1] || build(:bot),
      :vm => args[2] || build(:vm)
    )
  end
end

def Object.const_missing(c)
  EmulationSystem::Emulation.const_get(c)
end

class Numeric
  def approximately_equal_to?(n, delta = 0.0001)
    (self - n).abs < delta
  end
end
