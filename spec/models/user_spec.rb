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

  describe ".matches" do
    it "should work" do
      fwv = Factory :firmware_version
      4.times { Factory :match }
      m1 = Factory :match, :first_version => fwv
      1.times { Factory :match }
      m2 = Factory :match, :first_version => fwv, :second_version => fwv
      3.times { Factory :match }

      fwv.firmware.user.matches.sort_by(&:id).should == [m1, m2].sort_by(&:id)
    end
  end

  describe ".relevant_comments" do
    it "should work if there are no comments, fws, matches at all" do
      [Comment, Match, Firmware].map(&:delete_all)

      u = Factory :user
      u.relevant_comments.should be_blank
    end

    it "should work and be sorted by creation time" do
      fwv = Factory :firmware_version
      fw = fwv.firmware
      u = fw.user

      4.times { Factory(:comment, :commentable => Factory(:match)) }
      m1 = Factory :match, :first_version => fwv
      1.times { Factory(:comment, :commentable => Factory(:match)) }
      m2 = Factory :match, :first_version => fwv, :second_version => fwv
      m3 = Factory :match, :first_version => fwv, :user => u
      3.times { Factory(:comment, :commentable => Factory(:match)) }


      comments = [
        Factory( :comment, :user => u ),
        Factory( :comment, :user => u ),
        Factory( :comment, :commentable => fw ),
        Factory( :comment, :commentable => m1 ),
        Factory( :comment, :commentable => m1 ),
        Factory( :comment, :commentable => m1 ),
        Factory( :comment, :commentable => m2 ),
        Factory( :comment, :commentable => u ),
      ]

      u.relevant_comments.sort_by(&:id).should == comments.sort_by(&:id)
    end
  end
end
