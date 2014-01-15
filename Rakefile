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
task :run, :url do |t, args|
  Bundler.require(:debug)
  require 'github_archive_parser'
  GitHubArchiveParser::Processor.new.process(args[:url])
end

task :default => :spec
