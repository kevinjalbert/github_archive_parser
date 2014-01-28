#!/usr/bin/env rake

require 'rake/clean'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

CLOBBER.include('coverage')

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*spec.rb"
end

desc "Run GitHub Archive Parser on specified url (for debugging)"
task :debug_process_url, :url do |t, args|
  Bundler.require(:debug)
  require 'github_archive_parser'

  github_archive_parser = GitHubArchiveParser::CLI.new
  github_archive_parser.options.debug = true
  github_archive_parser.process(args)
end

desc "Run GitHub Archive Parser since a specified time (for debugging)"
task :debug_process_since, :since do |t, args|
  Bundler.require(:debug)
  require 'github_archive_parser'

  github_archive_parser = GitHubArchiveParser::CLI.new
  github_archive_parser.options.debug = true
  github_archive_parser.options.since = args[:since]
  github_archive_parser.process(args)
end

desc "Run GitHub Archive Parser between two times (for debugging)"
task :debug_process_between, :since, :until do |t, args|
  Bundler.require(:debug)
  require 'github_archive_parser'

  github_archive_parser = GitHubArchiveParser::CLI.new
  github_archive_parser.options.debug = true
  github_archive_parser.options.since = args[:since]
  github_archive_parser.options.until = args[:until]
  github_archive_parser.process(args)
end

task :default => :spec
