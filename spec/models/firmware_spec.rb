require 'spec_helper'

describe Firmware do
  it "should create a new instance given valid attributes" do
    Factory :firmware
  end

  [:name, :user_id].each do |field|
    it "should not create a new instance without '#{field}'" do
      Factory.build(:firmware, field => nil).should_not be_valid
    end
  end

  it "should not be valid with too long name" do
    Factory.build(:firmware, :name => "a"*100).should_not be_valid
  end

  describe "nested building" do
    it "should be creatable with version" do
      fw = Firmware.new :name => "Blah", :user => Factory(:user)
      fw.versions.build :code => "#foo"

      fw.save!

      fw.reload
      fw.versions.count.should == 1
      fw.version.code.should == "#foo"
      fw.version.number.should == 1
    end

    it "should not be creatable without version" do
      fw = Firmware.new :name => "Blah", :user => Factory(:user)

      fw.save
      fw.should have(1).error_on(:versions)
    end
  end

  describe "#versions.last_number" do
    it "should return nil if there are is only one versions" do
      fw = Factory :firmware
      fw.versions.last_number.should == 1
    end

    it "should return number of last version correctly" do
      fw = Factory :firmware

      2.times { fw.versions.build; fw.save; fw.reload }
      fw.versions.last_number.should == 3

      2.times { fw.versions.last.destroy;   fw.reload }
      2.times { fw.versions.build; fw.save; fw.reload }
      fw.versions.last_number.should == 3

      2.times { fw.versions.first.destroy;  fw.reload }
      2.times { fw.versions.build; fw.save; fw.reload }
      fw.versions.last_number.should == 5
    end
  end
end
