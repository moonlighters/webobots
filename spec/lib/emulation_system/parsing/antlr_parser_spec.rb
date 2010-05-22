require 'emulation_system_helper'

describe EmulationSystem::Parsing::ANTLRParser do
  it "should be callable" do
    call("").should == "block"
  end

  it "should parse assignments" do
    call("a = 3\nb=4").should == "(block (= a 3) (= b 4))"
  end

  describe ", if clauses:" do
    it "should parse if clauses without else" do
      call("if a-3 \n  b=4\nend").should == "(block (if (- a 3) (block (= b 4))))"
    end

    it "should parse if clauses with else" do
      call("if a-3\n  b=4\nelse\n  b=0\nend").should == "(block (if (- a 3) (block (= b 4)) (block (= b 0))))"
    end

    it "should parse nested if-else" do
      call("if A\n  a=4\nelse if B\n  b=4\nelse\n  c=4\nend\nend").should == "(block (if A (block (= a 4)) (block (if B (block (= b 4)) (block (= c 4))))))"
      # this double end needed ------------------------------^
    end
  end

  it "should raise errors" do
    lambda{ call("if(a-3 \nend") }.should raise_error
    lambda{ call("a + 2") }.should raise_error
  end

  it "should parse loops" do
    call("while(a+b)\n  b = b +3.2\nend").should == "(block (while (+ a b) (block (= b (+ b 3.2)))))"
  end

  it "should parse function defs " do
    call("def foo()\na = foo()\nreturn a\nend\n").should == "(block (funcdef foo params (block (= a (funccall foo params)) (return a))))"
  end
  
  describe ", fuctions" do
    it "should distinguish function calls from identifiers" do
      call("x = a + b * (c)").should == "(block (= x (+ a (* b c))))"
      call("x = a + b(c)").should == "(block (= x (+ a (funccall b (params c)))))"
    end
    
    it "should parse function calls with different number of params" do
      call("f(a,b,c,d)\ng()").should == "(block (funccall f (params a b c d)) (funccall g params))"
    end

    it "should not treat a funtion call without newline as a statement" do
      call("f(b)").should == "(block (funccall f (params b)))"
      lambda{ call("f(b) f(c)") }.should raise_error
    end
  end
  
  private
  def call(code)
    EmulationSystem::Parsing::ANTLRParser.call code
  end
end
