require 'spec_helper'

include FirmwaresHelper

describe FirmwaresHelper do
  before do
    @fw = Factory :firmware
    @fwv = Factory :firmware_version, :firmware => @fw
    @fw.reload
  end

  describe "#link_to_firmware" do
    before do
      mock(self).firmware_path(@fw) { "/some_path" }
    end

    it "should generate link to firmware with default text" do
      mock(self).h(@fw.name) { @fw.name }
      mock(self).link_to "#{@fw.name} (версия ##{@fwv.number})",
                         "/some_path",
                         {}
      link_to_firmware(@fw)
    end

    it "should generate link to firmware without version" do
      mock(self).h(@fw.name) { @fw.name }
      mock(self).link_to "#{@fw.name}",
                         "/some_path",
                         {}
      link_to_firmware(@fw, :no_version => true)
    end

    it "should generate link to firmware with given text" do
      mock(self).link_to "abccba",
                         "/some_path",
                         {}
      link_to_firmware(@fw, :text => "abccba")
    end

    it "should pass html params to link_to" do
      mock(self).link_to "abccba",
                         "/some_path",
                         {:class => "class"}
      link_to_firmware(@fw, :text => "abccba", :class => "class")
    end
  end

  describe "#link_to_firmware_version" do
    before do
      mock(self).show_firmware_version_path( :number => @fwv.number, :id => @fw ) { '/path_yeah' }
    end

    it "should generate link to firmware version with default text" do
      mock(self).h(@fw.name) { @fw.name }
      mock(self).link_to %Q{"#{@fw.name}" версии #{@fwv.number}},
                         "/path_yeah"
      link_to_firmware_version(@fwv)
    end
  end

  describe "#format_code" do
    %w{if else end while def return @log or and not}.each do |kw|
      it "should highlight keyword #{kw}" do
        hw = "<strong>#{kw}</strong>" # highlighted kw
        format_code("bla-bla\n#{kw} bla-bla\n   #{kw}\na b c #{kw}").should ==
                    "bla-bla\n#{hw} bla-bla\n   #{hw}\na b c #{hw}"
      end
    end
    it "should highlight comments" do
      format_code("bla-bla #comment\n# another comment \nbla-bla").should ==
                  "bla-bla <i>#comment</i>\n<i># another comment </i>\nbla-bla"
    end
  end
end
