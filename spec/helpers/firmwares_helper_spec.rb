require 'spec_helper'

include FirmwaresHelper

describe FirmwaresHelper do
  describe "(links) " do
    before :all do
      @fw = Factory :firmware, :name => "Cool"
    @fwv = Factory :firmware_version, :firmware => @fw
    @fw.reload
  end

  describe "#link_to_firmware" do
    before { @path = user_firmware_path(@fw.user, @fw) }

    it "should generate link to firmware with default text" do
        link_to_firmware(@fw).should == link_to("Cool", @path)
    end

    it "should generate link to firmware with given text" do
        link_to_firmware(@fw, :text => "foobar").should == link_to("foobar", @path)
    end

    it "should pass html params to link_to" do
        link_to_firmware(@fw, :class => "klass").should == link_to("Cool", @path, :class => "klass")
    end
  end

  describe "#link_to_firmware_version" do
    before { @path = user_firmware_version_path(:user_id => @fw.user, :id => @fw, :number => @fwv.number) }

    it "should generate link to firmware version with default text" do
        link_to_firmware_version(@fwv).should == link_to("Cool #2", @path)
    end

    it "should generate link to firmware version without version info" do
        link_to_firmware_version(@fwv, :no_version => true).should == link_to("Cool", @path)
    end

    it "should generate link to firmware version with given text" do
        link_to_firmware_version(@fwv, :text => "foobar").should == link_to("foobar", @path)
    end

    it "should pass options to link_to" do
        link_to_firmware_version(@fwv, :class => "klass").should == link_to("Cool #2", @path, :class => "klass")
      end
    end
  end

  describe "#format_code" do
    %w{if else end while def return @log or and not}.each do |kw|
      it "should highlight keyword #{kw}" do
        hw = "<strong>#{kw}</strong>" # highlighted kw
        format_code("bla-bla\n#{kw} bla < bla\n   #{kw}\na b not_a_@log #{kw}").should ==
                    "bla-bla\n#{hw} bla &lt; bla\n   #{hw}\na b not_a_@log #{hw}"
      end
    end
    it "should highlight comments" do
      format_code("bla-bla #comment\n# another comment \nbla-bla").should ==
                  "bla-bla <i>#comment</i>\n<i># another comment </i>\nbla-bla"
    end
  end
end
