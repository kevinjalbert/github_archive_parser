require 'spec_helper'

include GitHubArchiveParser

describe Processor do
  let (:processor) { GitHubArchiveParser::Processor.new }
  context "process url" do

    it "should fail on an invalid text" do
      expect {processor.process_url("dummydata")}.to raise_error(RuntimeError)
    end

    it "should fail on an invalid URL" do
      expect {processor.process_url("http://data.githubarchive.org/dummydata.json.gz")}.to raise_error(OpenURI::HTTPError)
    end

    it "should fail on an wrong domain URL" do
      expect {processor.process_url("http://data.wrongdomain.org/dummydata.json.gz")}.to raise_error(RuntimeError)
    end
  end

  context "process since" do
    it "should call process_between(since, 'Now')" do
      since_time = 'Yesterday'
      until_time = 'Now'
      processor.should receive(:process_between).with(since_time, until_time)
      processor.process_since(since_time)
    end
  end

  context "process between" do
    it "should call process_url(url) for as many hour intervals between two times (hours)" do
      since_time = '12 hours ago'
      until_time = '6 hours ago'
      processor.should receive(:process_url).exactly(6).times
      processor.process_between(since_time, until_time)
    end

    it "should call process_url(url) for as many hour intervals between two times (days)" do
      since_time = '3 days ago'
      until_time = '1 day ago'
      processor.should receive(:process_url).exactly(48).times
      processor.process_between(since_time, until_time)
    end

    it "should call process_url(url) for as many hour intervals between two times (months)" do
      since_time = 'April 1 2012 at 12pm'
      until_time = 'June 1 2012 at 12pm'

      # (24 hours * (April 30 days + May 31 days)) - last hour = 1463 hours
      processor.should receive(:process_url).exactly(1463).times
      processor.process_between(since_time, until_time)
    end

    it "should call process_url(url) for as many hour intervals between two times (years)" do
      since_time = 'April 1 2011 at 12pm'
      until_time = 'April 1 2013 at 12pm'

      # ((Number of days between April 1 2011 and April 1 2013) * 24 hours) - last hour = 731 days * 24 hours = 17543 hours
      processor.should receive(:process_url).exactly(17543).times
      processor.process_between(since_time, until_time)
    end
  end
end

