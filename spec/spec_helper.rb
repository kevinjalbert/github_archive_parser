$:.unshift File.expand_path("../../lib", __FILE__)

require 'pathname'
require 'tmpdir'

home_dir = Pathname.new(Dir.pwd)
spec_dir = home_dir + "spec"

FIXTURE_PATH = spec_dir + "fixtures/"

Dir.glob(spec_dir + 'support/**/*.rb') { |file| require file }

require 'github_archive_parser/initialize'

def fixture(file)
  Pathname.new(FIXTURE_PATH + file)
end

RSpec.configure do |config|
  config.before do
    %w[debug info warn error fatal].each do |level|
      GitHubArchiveParser::Log.stub(level)
    end
  end
end
