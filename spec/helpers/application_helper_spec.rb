require 'spec_helper'

include ApplicationHelper

describe ApplicationHelper do
  describe "#format_datetime" do
    it "should format date and time" do
      format_datetime( Time.local 2010, 'feb', 13, 19, 0 ).should ==
                       "13 февраля 2010, 19:00"
    end
  end

  describe "#pl" do
    it "should do nothing with simple format string" do
      pl("яблоко", :who_cares).should == "яблоко"
    end

    it "should substitute %? with number" do
      pl("%? яблоко", 1).should == "1 яблоко"
    end

    it "should substitute all %? with number" do
      pl("%? яблоко (только %?)", 1).should == "1 яблоко (только 1)"
    end

    it "should substitute %{one,few,many} with 'one'" do
      pl("1 %{яблоко,яблока,яблок}", 1).should == "1 яблоко"
    end

    it "should substitute %{one,few,many} with 'few'" do
      pl("2 %{яблоко,яблока,яблок}", 2).should == "2 яблока"
    end

    it "should substitute %{one,few,many} with 'many'" do
      pl("10 %{яблоко,яблока,яблок}", 10).should == "10 яблок"
    end

    it "should substitute %{one,few,} with ''" do
      pl("10 яблок%{о,а,}", 10).should == "10 яблок"
    end

    it "should substitute %{,,} with ''" do
      pl("в грузии один яблок%{,,,} всегда один яблок%{,,}", 10).should == "в грузии один яблок всегда один яблок"
    end

    it "should substitute %{one,few,many,other} with 'other'" do
      pl("0.5 %{яблоко,яблока,яблок,яблока}", 0.5).should == "0.5 яблока"
    end

    it "should substitute many %{...}" do
      pl("пада%{ет,ют,ют} %? яблок%{о,а,}", 4).should == "падают 4 яблока"
    end
  end
end
