require 'spec_helper'

describe Comment do
  it "should create a new instance given valid attributes" do
    Factory :comment
  end

  [:comment, :user].each do |field|
    it "should not create a new instance wthout '#{field}'" do
      Factory.build(:comment, field => nil).should_not be_valid
    end
  end

  it "should not be valid with blank comment" do
    Factory.build(:comment, :comment => "").should_not be_valid
  end

  it "should not be valid with too long comment" do
    Factory.build(:comment, :comment => "a"*1001).should_not be_valid
  end
end
