require 'emulation_system_helper'

describe EmulationSystem::Parsing::ANTLRParser do
  it "should be callable" do
    call("").should == "block"
  end

  it "should parse assignments" do
    call("a = 3\nb=4").should == "(block (= a 3) (= b 4))"
  end

  it "should parse if clauses without else" do
    call("if a-3 \n  b=4\nend").should == "(block (if (- a 3) (block (= b 4))))"
  end

  it "should parse if clauses with else" do
    call("if a-3\n  b=4\nelse\n  b=0\nend").should == "(block (if (- a 3) (block (= b 4)) (block (= b 0))))"
  end

  it "should raise errors" do
    lambda{ call("if(a-3 \nend") }.should raise_error
    lambda{ call("a + ") }.should raise_error
  end

  it "should parse nested if-else" do
    call("if A\n  a=4\nelse if B\n  b=4\nelse\n  c=4\nend\nend").should == "(block (if A (block (= a 4)) (block (if B (block (= b 4)) (block (= c 4))))))"
    # this double end needed ------------------------------^
  end

  it "should parse loops"
  it "should parse function defs "
  it "should parse function calls " do
    call("a + b * (c)").should == "(block (+ a (* b c)))"
    call("a + b(c)").should == "(block (+ a (funccall c)))"
  end

  
  private
  def call(code)
    EmulationSystem::Parsing::ANTLRParser.call code
  end
end
