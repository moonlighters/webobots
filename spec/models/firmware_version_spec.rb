require 'spec_helper'

describe FirmwareVersion do
  it "should create a new instance given valid attributes" do
    Factory.create :firmware_version
  end

  it "should not create a new instance without firmware" do
    lambda do
      Factory :firmware_version, :firmware => nil
    end.should raise_error ActiveRecord::StatementInvalid
  end

  [:message].each do |field|
    it "should create a new instance without '#{field}'" do
      Factory.build(:firmware_version, field => nil).should be_valid
    end
  end

  [:code, :message].each do |field|
    it "should not be valid with long #{field}" do
      Factory.build(:firmware_version, field => "x"*100_000).should_not be_valid
    end
  end

  it "should not create a new instance with not unique version number" do
    fw = Factory :firmware
    Factory :firmware_version, :firmware => fw, :number => 7
    Factory.build(:firmware_version, :firmware => fw, :number => 7).should_not be_valid
  end

  it "should be able to create a new instance with not unique version number when previous was deleted" do
    fw = Factory :firmware
    fwv = Factory :firmware_version, :firmware => fw, :number => 7
    fwv.destroy
    Factory.build(:firmware_version, :firmware => fw, :number => 7).should be_valid
  end
end
