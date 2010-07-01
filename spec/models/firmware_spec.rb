require 'spec_helper'

describe Firmware do
  it "should create a new instance given valid attributes" do
    Factory.create :firmware
  end

  [:name, :user_id].each do |field|
    it "should not create a new instance without '#{field}'" do
      Factory.build(:firmware, field => nil).should_not be_valid
    end
  end

  it "should not be valid with too long name" do
    Factory.build(:firmware, :name => "a"*100).should_not be_valid
  end

  describe "#versions.last_number" do
    it "should return nil if there are no versions" do
      fw = Factory :firmware
      fw.versions.last_number.should be_nil
    end

    it "should return nil if there were versions being deleted" do
      fw = Factory :firmware
      fwv = Factory :firmware_version, :firmware => fw
      fwv.destroy
      fw.reload
      fw.versions.last_number.should be_nil
    end

    it "should return number of last version correctly" do
      fw = Factory :firmware
      Factory :firmware_version, :firmware => fw
      Factory :firmware_version, :firmware => fw.reload
      fwv = Factory :firmware_version, :firmware => fw.reload
      fwv.destroy
      Factory :firmware_version, :firmware => fw.reload
      fw.reload.versions.last_number.should == 3
    end
  end
end
