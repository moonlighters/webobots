require 'emulation_system_helper'

describe EmulationSystem::Parsing::ANTLRParser do
  it "should be callable" do
    call("").should == "block"
  end

  it "should parse unary operations" do
    call("r = -r").should == "(block (= r (uminus r)))"
    call("r = +r").should == "(block (= r (uplus r)))"
  end

  it "should parse assignments" do
    call("a = 3\nb=4").should == "(block (= a 3) (= b 4))"
  end

  describe "(with if clauses)" do
    it "should parse if clauses without else" do
      call("if a!=3 \n  b=4\nend").should == "(block (if (!= a 3) (block (= b 4))))"
    end

    it "should parse if clauses with else" do
      call("if a>3\n  b=a-3\nelse\n  b=0\nend").should == "(block (if (> a 3) (block (= b (- a 3))) (block (= b 0))))"
    end

    it "should parse nested if-else" do
      call("if A\n  a=4\nelse if B\n  b=4\nelse\n  c=4\nend\nend").should == "(block (if A (block (= a 4)) (block (if B (block (= b 4)) (block (= c 4))))))"
    end
  end

  it "should raise errors" do
    lambda{ call("if(a-3 \nend") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
    lambda{ call("a + 2") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
    lambda{ call("b = a + 2;") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
  end

  it "should parse loops" do
    call("while(b < 100500)\n  b = b +3.2\nend").should == "(block (while (< b 100500) (block (= b (+ b 3.2)))))"
  end

  describe "(with functions)" do
    it "should parse function defs " do
      call("def foo()\na = foo()\nreturn a\nend\n").should == "(block (funcdef foo params (block (= a (funccall foo params)) (return a))))"
    end

    it "should distinguish function calls from identifiers" do
      call("x = a + b * (c)").should == "(block (= x (+ a (* b c))))"
      call("x = a + b(c)").should == "(block (= x (+ a (funccall b (params c)))))"
    end
    
    it "should parse function calls with different number of params" do
      call("f(a,b,c,d)\ng()").should == "(block (funccall f (params a b c d)) (funccall g params))"
    end

    it "should not treat a funtion call without newline as a statement" do
      call("f(b)").should == "(block (funccall f (params b)))"
      lambda{ call("f(b) f(c)") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
    end
  end

  describe "(with expressions)" do
    it "should allow negative numbers, but in an unusual way" do
      call("r=-2").should == "(block (= r (uminus 2)))"
    end
    it "should parse simple multiplications" do
      call("r=a*2.2").should == "(block (= r (* a 2.2)))"
      call("r=a/2.2").should == "(block (= r (/ a 2.2)))"
    end
    it "should parse simple additions" do
      call("r=2+2").should == "(block (= r (+ 2 2)))"
      call("r=2-2").should == "(block (= r (- 2 2)))"
    end
    it "should parse simple comparisons" do
      %w{> < >= <= == !=}.each do |op|
        call("r=a#{op}b").should == "(block (= r (#{op} a b)))"
      end
    end
    it "should parse simple boolean expressions" do
      call("r = not bad").should == "(block (= r (not bad)))"
      call("r = to_be or not_to_be").should == "(block (= r (or to_be not_to_be)))"
      call("r = head and shoulders").should == "(block (= r (and head shoulders)))"
    end
    it "should parse complex expressions" do
      call("r = (a + b)*(a - b > 2) != b*c or aa and not bb >= cc - dd/2").should ==
        "(block (= r (or (!= (* (+ a b) (> (- a b) 2)) (* b c)) (and aa (not (>= bb (- cc (/ dd 2))))))))"
    end
    it "should parse any amount of unary operators" do
      call("r=---a").should == "(block (= r (uminus (uminus (uminus a)))))"
      call("r=+++a").should == "(block (= r (uplus (uplus (uplus a)))))"
      call("r=+-+a").should == "(block (= r (uplus (uminus (uplus a)))))"
      call("r=not not not a").should == "(block (= r (not (not (not a)))))"
    end
  end

  it "should parse @log directive" do
    call(%Q{ a=2\n@log "a", a\na=3 }).should == %Q{(block (= a 2) (log "a" a) (= a 3))}
  end

  it "should ignore comments" do
    call("a = 2 # comment\r\n# anoter\na=3").should == "(block (= a 2) (= a 3))"
  end

  it "should not ignore garbage at the end of file" do
    lambda{ call("a=3\n2") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
  end
  
  private
  def call(code)
    EmulationSystem::Parsing::ANTLRParser.call code
  end
end
