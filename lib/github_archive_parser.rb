require 'github_archive_parser/initialize'

module GitHubArchiveParser
  class Processor
    attr_reader :options

    def initialize
      @options = OpenStruct.new(
        debug: false,
      )
      parse_options
      determine_log_level

      # Create the concrete handlers and store them for future use
      create_event_handlers
    end

    def process(url)
      Log.info "Processing #{url}"
      if (!url.nil? && url.start_with?("http://data.githubarchive.org/"))
        gz = open(url)
        js = Zlib::GzipReader.new(gz).read

        Yajl::Parser.parse(js) do |event|
          event_class = class_from_string("GitHubArchiveParser::#{event['type']}")
          event_handler = @event_handlers[event_class]

          event_handler.each { |handler|
            if !handler.nil? && handler.respond_to?(:parse)
              handler.parse(event)
            end
          }
        end
      else
        Log.warn "URL[#{url}] does not belong to http://data.githubarchive.org/"
      end
    end

    def parse_options
      OptionParser.new do |opt|
        opt.version = VERSION
        opt.on "-d", "--debug", "Debug output (shows DEBUG level log statements)" do
          options.debug = true
        end
        opt.on "-q", "--quite", "Hide all output (shows only UNKNOWN level log statements)" do
          options.quite = true
        end
      end.parse!
    end

    private

    def determine_log_level
      if options.debug
        Log.level = Logger::DEBUG
        Log.use_debug
      elsif options.quite
        Log.level = Logger::UNKNOWN
      else
        Log.level = Logger::INFO
      end
    end

    def class_from_string(string)
      begin
        string.split('::').inject(Object) do |mod, class_name|
          mod.const_get(class_name)
        end
      rescue Exception
        Log.warn "Event #{string} not found"
        nil
      end
    end

    def create_event_handlers
      @event_handlers = {}

      # Probably can do something to not hardcode this
      # Iterate over the event types
      [CommitCommentEvent, CreateEvent, DeleteEvent,
      DeploymentEvent, DeploymentStatusEvent, DownloadEvent,
      FollowEvent, ForkApplyEvent, ForkEvent,
      GistEvent, GollumEvent, IssueCommentEvent,
      IssueCommentEvent, IssuesEvent, MemberEvent,
      PublicEvent, PullRequestEvent, PullRequestReviewCommentEvent,
      PushEvent, ReleaseEvent, StatusEvent,
      TeamAddEvent, WatchEvent].each do | event_type |

        # Map list of concrete event handler to their event type
        @event_handlers[event_type] = event_type.descendants.map { |handler|
          handler.new
        }
      end
    end
  end
end
