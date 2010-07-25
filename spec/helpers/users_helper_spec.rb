require 'spec_helper'

include UsersHelper

describe UsersHelper do
  before do
    @u = Factory :user, :login => "John"
  end

  describe "#link_to_user" do
    it "should generate link to user with his login as text" do
      mock(@u).gravatar_url(anything) { "http://avatar.png" }

      link_to_user(@u).should == %Q|<a href="/users/#{@u.id}"><img alt="аватар" class="avatar_tiny" src="http://avatar.png" /></a> | +
                                 %Q|<a href="/users/#{@u.id}">John</a>|
    end
  end
end
