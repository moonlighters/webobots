require 'emulation_system_helper'

describe EmulationSystem::Parsing::ANTLRParser do
  it "should be callable" do
    call("").should == "block"
  end

  it "should parse unary operations" do
    call("r = -r").should == "(block (= r (uminus (var r))))"
    call("r = +r").should == "(block (= r (uplus (var r))))"
  end

  it "should parse assignments" do
    call("a = 3\nb=4").should == "(block (= a 3) (= b 4))"
  end

  describe "(with if clauses)" do
    it "should parse if clauses without else" do
      call("if a!=3 \n  b=4\nend").should == "(block (if (!= (var a) 3) (block (= b 4))))"
    end

    it "should parse if clauses with else" do
      call("if a>3\n  b=a-3\nelse\n  b=0\nend").should == "(block (if (> (var a) 3) (block (= b (- (var a) 3))) (block (= b 0))))"
    end

    it "should parse nested if-else" do
      call("if A\n  a=4\nelse if B\n  b=4\nelse\n  c=4\nend\nend").should == "(block (if (var A) (block (= a 4)) (block (if (var B) (block (= b 4)) (block (= c 4))))))"
    end
  end

  it "should raise errors" do
    lambda{ call("if(a-3 \nend") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
    lambda{ call("a + 2") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
    lambda{ call("b = a + 2;") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
  end

  it "should parse loops" do
    call("while(b < 100500)\n  b = b +3.2\nend").should == "(block (while (< (var b) 100500) (block (= b (+ (var b) 3.2)))))"
  end

  describe "(with functions)" do
    it "should parse function defs " do
      call("def foo()\na = foo()\nreturn a\nend\n").should == "(block (funcdef foo params (block (= a (funccall foo params)) (return (var a)))))"
    end

    it "should distinguish function calls from identifiers" do
      call("x = a + b * (c)").should == "(block (= x (+ (var a) (* (var b) (var c)))))"
      call("x = a + b(c)").should == "(block (= x (+ (var a) (funccall b (params (var c))))))"
    end

    it "should parse function calls with different number of params" do
      call("f(a,b,c,d)\ng()").should == "(block (funccall f (params (var a) (var b) (var c) (var d))) (funccall g params))"
    end

    it "should not treat a funtion call without newline as a statement" do
      call("f(b)").should == "(block (funccall f (params (var b))))"
      lambda{ call("f(b) f(c)") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
    end
  end

  describe "(with expressions)" do
    it "should allow negative numbers, but in an unusual way" do
      call("r=-2").should == "(block (= r (uminus 2)))"
    end
    it "should parse simple multiplications" do
      call("r=a*2.2").should == "(block (= r (* (var a) 2.2)))"
      call("r=a/2.2").should == "(block (= r (/ (var a) 2.2)))"
    end
    it "should parse simple additions" do
      call("r=2+2").should == "(block (= r (+ 2 2)))"
      call("r=2-2").should == "(block (= r (- 2 2)))"
    end
    it "should parse simple comparisons" do
      %w{> < >= <= == !=}.each do |op|
        call("r=a#{op}b").should == "(block (= r (#{op} (var a) (var b))))"
      end
    end
    it "should parse simple boolean expressions" do
      call("r = not bad").should == "(block (= r (not (var bad))))"
      call("r = to_be or not_to_be").should == "(block (= r (or (var to_be) (var not_to_be))))"
      call("r = head and shoulders").should == "(block (= r (and (var head) (var shoulders))))"
    end
    it "should parse complex expressions" do
      call("r = (a + b)*(a - b > 2) != b*c or aa and not bb >= cc - dd/2").should ==
        "(block (= r (or (!= (* (+ (var a) (var b)) (> (- (var a) (var b)) 2)) (* (var b) (var c))) (and (var aa) (not (>= (var bb) (- (var cc) (/ (var dd) 2))))))))"
    end
    it "should parse any amount of unary operators" do
      call("r=---a").should == "(block (= r (uminus (uminus (uminus (var a))))))"
      call("r=+++a").should == "(block (= r (uplus (uplus (uplus (var a))))))"
      call("r=+-+a").should == "(block (= r (uplus (uminus (uplus (var a))))))"
      call("r=not not not a").should == "(block (= r (not (not (not (var a))))))"
    end
  end

  describe "(with @log directive)" do
    it "should parse variables" do
      call(%Q{ a=2\n@log a, b\na=3 }).should == %Q{(block (= a 2) (log (var a) (var b)) (= a 3))}
    end

    it "should parse strings" do
      call(%Q{ a=2\n@log "value", "for debug:", a }).should == %Q{(block (= a 2) (log "value" "for debug:" (var a)))}
    end
  end

  it "should ignore comments" do
    call("a = 2 # comment\na=0# + another\n#only=comment\na=3").should == "(block (= a 2) (= a 0) (= a 3))"
  end

  it "should not ignore garbage at the end of file" do
    lambda{ call("a=3\n2") }.should raise_error(EmulationSystem::Errors::WFLSyntaxError)
  end

  it "should parse return statements" do
    call("return 5").should == "(block (return 5))"
    call("return").should == "(block return)"
  end

  private
  def call(code)
    EmulationSystem::Parsing::ANTLRParser.call code
  end
end
