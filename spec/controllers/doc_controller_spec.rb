require 'spec_helper'

describe DocController do
  include AuthlogicSpecHelpers
  integrate_views
  
  %w{waffle_language runtime_library tour tutorial}.each do |action|
    describe "#{action}" do
      it "should work" do
        login # TODO: later login will not be required
        get action
        response.should be_success
      end
    end
  end
end
