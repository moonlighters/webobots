require 'emulation_system_helper'

describe EmulationSystem::Parsing::ANTLRParser do
  it "should be callable" do
    call("").should == "block"
  end

  it "should parse assignments" do
    call("a = 3\nb=4").should == "(block (= a 3) (= b 4))"
  end

  it "should parse if clauses without else" do
    call("if(a-3)\n  b=4\nend").should == "(block (if (- a 3) (block (= b 4))))"
  end

  it "should parse if clauses with else" do
    call("if(a-3)\n  b=4\nelse\n  b=0\nend").should == "(block (if (- a 3) (block (= b 4)) (block (= b 0))))"
  end
  
  private
  def call(code)
    EmulationSystem::Parsing::ANTLRParser.call code
  end
end
