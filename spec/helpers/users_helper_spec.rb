require 'spec_helper'

include UsersHelper

describe UsersHelper do
  before do
    @u = Factory :user
  end

  describe "#link_to_user" do
    it "should generate link to user with his login as text" do
      mock(self).user_path(@u) { "/his_path" }
      mock(self).h(@u.login) { @u.login }
      mock(self).link_to @u.login, "/his_path"

      link_to_user @u
    end
  end
end
