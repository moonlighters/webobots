require 'emulation_system_helper'

describe V2D do
  it "#new should create with arguments" do
    v = V2D.new(1,2)
  end

  it "#[] should create with arguments" do
    v = V2D[1, 2]
  end

  it "#x should return first coordinate" do
    V2D[1, 2].x.should == 1
  end

  it "#y should return second coordinate" do
    V2D[1, 2].y.should == 2
  end

  it "#x= should set first coordinate" do
    v = V2D[1, 2]
    v.x = 3
    v.should == V2D[3, 2]
  end

  it "#y= should set second coordinate" do
    v = V2D[1, 2]
    v.y = 3
    v.should == V2D[1, 3]
  end

  describe "operations" do
    before do
      @v1 = V2D[1.0, 2]
      @v2 = V2D[3, 9.0]
    end

    describe "#+" do
      it "should return new vector as sum" do
        (@v1+@v2).should == V2D[4, 11]
      end
    end

    describe "#-" do
      it "should return new vector as difference" do
        (@v1-@v2).should == V2D[-2, -7]
      end
    end

    describe "#*" do
      it "should return new vector as product" do
        (@v1*3).should == V2D[3, 6]
      end
    end

    describe "#/" do
      it "should return new vector as quotient" do
        (@v1/2).should == V2D[0.5, 1]
      end

      it "should return new vector as quotient even with zero divisor" do
        r = @v1/0
        r.x.should be_infinite
        r.y.should be_infinite
      end
    end

    describe "#abs" do
      it "should return absolute value of vector" do
        @v1.abs.should == Math::sqrt(5)
      end
    end
  end
end

