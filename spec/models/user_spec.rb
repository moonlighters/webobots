require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    Factory.create :user
  end

  [:login, :email, :code].each do |field|
    it "should not create a new instance without '#{field}'" do
      Factory.build(:user, field => nil).should_not be_valid
    end
  end

  it "should not be valid with too long login" do
    Factory.build(:user, :login => "a"*100).should_not be_valid
  end

  describe "creating with invite code" do
    before do
      i = Invite.find_or_create_by_code 'DEADBEAF'
    end

    it "should not be valid given invalid code" do
      Factory.build(:user, :code => 'not a DEADBEAF').should_not be_valid
    end

    it "should be valid given valid code" do
      u = Factory.build(:user, :code => 'DEADBEAF')
      u.should be_valid
      u.save.should be_true
    end
  end

  describe "#owns?" do
    it "should return false if object hasn't #user" do
      mock(obj = Object.new)
      User.new.owns?(obj).should be_false
    end

    it "should return false if object's user is not given user" do
      mock(obj = Object.new).user { :other }
      User.new.owns?(obj).should be_false
    end

    it "should return true if object's user is given user" do
      u = User.new
      mock(obj = Object.new).user { u }
      u.owns?(obj).should be_true
    end
  end
end
