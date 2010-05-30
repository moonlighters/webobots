require 'spec_helper'

include ApplicationHelper

describe ApplicationHelper do
  describe "#format_datetime" do
    it "should format date and time" do
      format_datetime( Time.local 2010, 'feb', 13, 19, 0 ).should ==
                       "13 февраля 2010, 19:00"
    end
  end
end
