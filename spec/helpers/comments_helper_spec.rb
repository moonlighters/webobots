require 'spec_helper'

describe CommentsHelper do
  include CommentsHelper

  describe "#format_comment_text" do
    it "should add a <br/> tag to every newline character in text" do
      format_comment_text( "a\naaa\n\nd" ).should == "a<br/>\naaa<br/>\n<br/>\nd"
    end

    it "should not change text without newline characters" do
      ["aaa", "aa\taa", "", "bb\r"].each do |s|
        format_comment_text( s ).should == s
      end
    end

    it "should do escaping" do
      format_comment_text( "a\na<a>a\n\nd" ).should == "a<br/>\na&lt;a&gt;a<br/>\n<br/>\nd"
    end
  end
end
