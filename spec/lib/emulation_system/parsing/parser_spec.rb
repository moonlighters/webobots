require 'emulation_system_helper'

describe EmulationSystem::Parsing::Parser do
  it "should be creatable" do
    EmulationSystem::Parsing::Parser.new ""
  end

  it "should parse to ir" do
    parse( "(block stat1 stat2)" ).should be_a EmulationSystem::IR
  end

  it "should parse simple tree returned by external parser" do
    parse( "(block stat1 stat2)" ).root.should == n(
      'block',
      [
        n('stat1'),
        n('stat2')
      ]
    )
  end

  it "should parse tree with only root" do
    parse( "root" ).root.should == n( 'root')
  end

  it "should parse tree with data of digits" do
    parse( "(some 3 2)" ).root.should == n( 'some', [ n('3'), n('2')] )
  end

  it "should parse tree with data of random chars" do
    parse( "(= ! ?)" ).root.should == n( '=', [ n('!'), n('?')] )
  end

  it "should raise error on unexpected end of source" do
    ['(root', '(root (child )', '((((('].each do |s|
      lambda { parse s }.should raise_error
    end
  end

  it "should raise error on odd symbols at the end" do
    ['root)', 'root (child)', '(root) child'].each do |s|
      lambda { parse s }.should raise_error
    end
  end

  private
  def parse(tree)
    mock(parser = Object.new).call("some code") { tree }
    EmulationSystem::Parsing::Parser.new("some code", parser).parse
  end

  def n(data, children=[])
    EmulationSystem::IR::Node[data, children]
  end
end
