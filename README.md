# GitHub Archive Parser
[![Gem Version](https://badge.fury.io/rb/github_archive_parser.png)](http://badge.fury.io/rb/github_archive_parser)
[![Build Status](https://travis-ci.org/kevinjalbert/github_archive_parser.png?branch=master)](https://travis-ci.org/kevinjalbert/github_archive_parser)
[![Coverage Status](https://coveralls.io/repos/kevinjalbert/github_archive_parser/badge.png)](https://coveralls.io/r/kevinjalbert/github_archive_parser)
[![Code Climate](https://codeclimate.com/github/kevinjalbert/github_archive_parser.png)](https://codeclimate.com/github/kevinjalbert/github_archive_parser)
[![Dependency Status](https://gemnasium.com/kevinjalbert/github_archive_parser.png)](https://gemnasium.com/kevinjalbert/github_archive_parser)

## Introduction
This gem provides a streamlined method for parsing the [GitHub Archive](http://www.githubarchive.org/). You have the ability to define custom event handlers for the different [22 GitHub Event Types](http://developer.github.com/v3/activity/events/types/). A custom event handler allows you to parse individual events as they are processed by the GitHub Archive Parser.

## Example
You want to print the name of newly created repositories. The first thing you need to do is create your own custom event handler which requires the following statement: `includes GitHubArchiveParser::CreateEvent`. This causes GitHub Archive Parser to call your custom event handler class anytime it encounters a *CreateEvent*. In your custom event handler you only require one method `def parser(event)`, which is executed when a *CreateEvent* is encountered. The event is a [Hashie::Mash](https://github.com/intridea/hashie#mash) object which allows you to access the values of the hash using simple *dot* notation. You can define as many unique custom event handlers as needed (even for the same event type).

    module AwesomeApplication
      class PrintCreateEvent
        include GitHubArchiveParser::CreateEvent

        def parse(event)
          # The event is a Hashie::Mash object for easy (dot) access
          puts "#{event.repository.owner}/#{event.repository.name}"
        end
      end
    end

When you have your custom event handlers setup you can simply start processing [GitHub Archive](http://www.githubarchive.org/) using `GitHubArchiveParser::Processor`. Currently you can process one hour blocks on an individual basis, or by specifing ranges.

    processor = GitHubArchiveParser::Processor.new
    processor.process_url("http://data.githubarchive.org/2012-04-11-15.json.gz")
    processor.process_since("One Month Ago")
    processor.process_between("One Week Ago", "Yesterday")
