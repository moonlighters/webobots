require 'spec_helper'

describe Invite do
  it "should create a new instance given valid attributes" do
    Factory :invite
  end

  it "should not be valid with too long comment" do
    Factory.build(:invite, :comment => "a"*100).should_not be_valid
  end
end
