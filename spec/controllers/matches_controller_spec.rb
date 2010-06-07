require 'spec_helper'

describe MatchesController do

  describe ".prevalidate" do
    before do
      # okay, let's have two firmwares, first for current_user and second for an opponent,
      # and let each have two versions, and let's try to make a match between them
      @user = Factory :user
      @another_user = Factory :user
      
      @fw1 = Factory :firmware, :user => @user, :available => true
      @fwv1_old = Factory :firmware_version, :firmware => @fw1
      @fw1.reload
      @fwv1 = Factory :firmware_version, :firmware => @fw1
      @fw1.reload

      @fw2 = Factory :firmware, :user => @another_user, :available => true
      @fwv2_old = Factory :firmware_version, :firmware => @fw2
      @fw2.reload
      @fwv2 = Factory :firmware_version, :firmware => @fw2
      @fw2.reload

      @match = Factory.build :match, :user => @user,
                                     :first_version => @fwv1,
                                     :second_version => @fwv2
    end

    it "should valid given valid firmwares" do
      MatchesController.prevalidate(@match).should be_true
    end

    it "should not be valid if none of firmwares belongs to user" do
      @fw1.update_attributes! :user => @another_user
      MatchesController.prevalidate(@match).should be_false
    end

    it "should not be valid if version of opponent's firmware is not the last" do
      @match.second_version = @fwv2_old
      MatchesController.prevalidate(@match).should be_false
    end

    it "should be valid even if version of current_user's firmware is not the last" do
      @match.first_version = @fwv1_old
      MatchesController.prevalidate(@match).should be_true
    end

    it "should not be valid if opponent's firmware is not available" do
      @fw2.available = false
      MatchesController.prevalidate(@match).should be_false
    end

    it "should be valid even if current_user's firmware is not available" do
      @fw1.available = false
      MatchesController.prevalidate(@match).should be_true
    end
  end
end
