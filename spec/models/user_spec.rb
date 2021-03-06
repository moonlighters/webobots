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
    Factory.build(:user, :login => "a"*21).should_not be_valid
  end

  describe "creating with invite code" do
    before do
      @invite = Factory :invite
    end

    it "should not be valid given invalid code" do
      Factory.build(:user, :code => 'not a valid code').should_not be_valid
    end

    it "should be valid given valid code" do
      u = Factory.build(:user, :code => @invite.code)
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

  describe ".relevant_comments" do
    it "should work if there are no comments, fws, matches at all" do
      [Comment, Match, Firmware].map(&:delete_all)

      u = Factory :user
      u.relevant_comments.should be_blank
    end

    it "should work" do
      fwv = Factory :firmware_version
      fw = fwv.firmware
      u = fw.user

      1.times { Factory(:comment, :commentable => Factory(:match)) }
      m1 = Factory :match, :first_version => fwv
      1.times { Factory(:comment, :commentable => Factory(:match)) }
      m2 = Factory :match, :first_version => fwv, :second_version => fwv
      m3 = Factory :match, :first_version => fwv, :user => u
      1.times { Factory(:comment, :commentable => Factory(:match)) }


      comments = [
        Factory( :comment, :user => u ),
        Factory( :comment, :commentable => fw ),
        Factory( :comment, :commentable => m1 ),
        Factory( :comment, :commentable => m2 ),
      ]

      u.relevant_comments.sort_by(&:id).should == comments.sort_by(&:id)
    end
  end
end
