require 'spec_helper'

describe FirmwareVersion do
  it "should create a new instance given valid attributes" do
    Factory.create :firmware_version
  end

  [:code, :firmware_id].each do |field|
    it "should not create a new instance without '#{field}'" do
      Factory.build(:firmware_version, field => nil).should_not be_valid
    end
  end

  it "should choose version numbers correctly" do
    fw = Factory :firmware
    
    fwv1 = Factory :firmware_version, :firmware => fw
    fwv1.number.should == 1
    
    fwv2 = Factory :firmware_version, :firmware => fw.reload
    fwv2.number.should == 2

    fw.reload.versions.should == [fwv1, fwv2]

    fwv2.destroy
    
    fwv3 = Factory :firmware_version, :firmware => fw.reload
    fwv3.number.should == 2
    
    fwv4 = Factory :firmware_version, :firmware => fw.reload
    fwv4.number.should == 3

    fw.reload.versions.should == [fwv1, fwv3, fwv4]
  end
end
