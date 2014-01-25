require 'spec_helper'

include GitHubArchiveParser

describe GitHubArchiveParser do
  context "process url" do
    let (:processor) { GitHubArchiveParser::Processor.new }

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
end

