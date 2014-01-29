require 'spec_helper'

include GitHubArchiveParser

describe Utilities do
  describe "#time_from_natural_language" do
    it "should raise an error with an invalid time" do
      expect { Utilities.time_from_natural_language('nil') }.to raise_error(RuntimeError)
    end

    it "should return a Time object" do
      time = Utilities.time_from_natural_language('August 1 2013 at 4am')
      time.should be_a(Time)
    end

    it "should return a UTC time" do
      time = Utilities.time_from_natural_language('August 1 2013 at 4am')
      time.utc?.should be_true
    end

    it "should return the correct time" do
      time = Utilities.time_from_natural_language('August 1 2013 at 4am')
      time.year.should eq(2013)
      time.month.should eq(8)
      time.day.should eq(1)
      time.hour.should eq(8)  # +4 hours due to UTC
    end
  end

  describe "#class_from_string" do
    it "should return a valid name of a module" do
      Utilities.class_from_string('Utilities').should eq(Utilities)
    end

    it "should return a valid name of a class" do
      Utilities.class_from_string('Processor').should eq(Processor)
    end

    it "should return a valid name of a class using full path" do
      Utilities.class_from_string('GitHubArchiveParser::Processor').should eq(Processor)
    end

    it "should return nil if class cannot be found" do
      Utilities.class_from_string('SpecialApplication::MassUnit').should be_nil
    end
  end
end

