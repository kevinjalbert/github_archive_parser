# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require 'github_archive_parser/version'

Gem::Specification.new do |gem|
  gem.homepage      = 'https://github.com/kevinjalbert/github_archive_parser'
  gem.authors       = ["Kevin Jalbert"]
  gem.email         = ["kevin.j.jalbert@gmail.com"]
  gem.name          = 'github_archive_parser'
  gem.version       = GitHubArchiveParser::VERSION
  gem.summary       = "Gem which parses GitHub Archive data"
  gem.description   = "Gem which parses GitHub Archive data"
  gem.require_paths = ["lib"]
  gem.files         = Dir['lib/**/*']
  gem.test_files    = Dir['spec/**/*_spec.rb']
  gem.required_ruby_version = '>= 1.9.3'
  gem.executables   = 'github_archive_parser'
end
