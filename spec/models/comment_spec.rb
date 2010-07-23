require 'spec_helper'

describe Comment do
  before do
    @commentable = Factory.create(:firmware)
  end
  
  def add_comment(attributes = {})
    @commentable.comments << Factory.build(:comment, attributes)
  end

  it "should create a new instance given valid attributes" do
    add_comment.should be_true
  end

  [:comment, :user].each do |field|
    it "should not create a new instance wthout '#{field}'" do
      add_comment(field => nil).should be_false
    end
  end

  it "should not be valid with too long comment" do
    add_comment(:comment => "a"*1001).should be_false
  end
end
