require 'spec_helper'

describe DocController do
  include AuthlogicSpecHelpers
  integrate_views
  before { logout }
  
  %w{waffle_language runtime_library tour tutorial}.each do |action|
    describe "#{action}" do
      it "should work" do
        get action
        response.should be_success
      end
    end
  end
end
