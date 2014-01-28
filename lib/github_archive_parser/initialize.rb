require 'pathname'
require 'ostruct'
require 'optparse'
require 'open-uri'
require 'zlib'
require 'yajl'
require 'hashie'
require 'chronic'

# Require event_handler first to prevent load order issues
require_relative './event_handler'
Dir.glob(File.dirname(__FILE__) + '/**/*.rb') { |file| require file }
