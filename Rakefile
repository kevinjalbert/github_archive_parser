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

  processor = GitHubArchiveParser::Processor.new
  processor.options.debug = true
  processor.process(args)
end

task :default => :spec
