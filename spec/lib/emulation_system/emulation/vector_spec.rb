require 'emulation_system_helper'

describe EmulationSystem::Emulation::Vector do
  before do
    @v = Vector.new 2, 3
  end

  it "should be creatable" do
    @v.x.should == 2
    @v.y.should == 3
  end

  describe ".[]" do
    it "should act as .new" do
      u = Vector[@v.x, @v.y]
      u.x.should == @v.x
      u.y.should == @v.y
    end 
  end
  
  describe "#+" do
    it "should add vectors" do
      u = @v + Vector.new(-0.5, +0.5)
      u.x.should == @v.x - 0.5
      u.y.should == @v.y + 0.5
    end

    it "should add to vector" do
      u = Vector.new 5, 15
      u += @v
      u.x.should == 5 + @v.x
      u.y.should == 15 + @v.y
    end
  end

  describe "#-" do
    it "should substract vectors" do
      u = @v - Vector.new(100, -50)
      u.x.should == @v.x - 100
      u.y.should == @v.y + 50
    end

    it "should substract from vector" do
      u = Vector.new -11, -11.1
      u -= @v
      u.x.should == -11 - @v.x
      u.y.should == -11.1 - @v.y
    end
  end

  describe "unary minus" do
    it "should negate vector" do
      u = -@v
      u.x.should == -@v.x
      u.y.should == -@v.y
    end
  end

  describe "#*" do
    it "should multiply vector by a scalar" do
      u = @v*1.5
      u.x.should == 1.5*@v.x
      u.y.should == 1.5*@v.y
    end
  end

  describe "#/" do
    it "should divide vector by a scalar" do
      u = @v/1.5
      u.x.should == @v.x/1.5
      u.y.should == @v.y/1.5
    end
  end

  describe "#abs" do
    it "should return vector norm" do
      Vector.new(3,4).abs.should == 5
    end
  end

  describe "#near?" do
    it "should return true if vectors are equal" do
      @v.should be_near_to @v, 0
      @v.should be_near_to @v, 1
    end

    it "should return true if distance between points represented by vectors is less than or equals to radius" do
      u = @v + Vector[3,4]
      @v.should be_near_to u, 5
      u.should be_near_to @v, 5
    end

    it "should return true if distance between points represented by vectors is less than or equals to radius" do
      u = @v + Vector[3,4]
      @v.should_not be_near_to u, 3
      u.should_not be_near_to @v, 3
    end
  end
end
