module GitHubArchiveParser
  class Processor

    def initialize
      create_event_handlers
    end

    def process_between(since_time, until_time)
      start_time = Chronic.parse(since_time)
      end_time = Chronic.parse(until_time)

      if start_time.nil?
        raise "Invalid since time: #{since_time}"
      end
      if end_time.nil?
        raise "Invalid until time: #{until_time}"
      end

      Log.info "Processing between #{start_time} and #{end_time}"
    end

    def process_since(since_time)
      process_between(since_time, 'Now')
    end

    def process_url(url)
      Log.info "Processing #{url}"
      if (!url.nil? && url.start_with?("http://data.githubarchive.org/"))

        begin
          gz = open(url)
          js = Zlib::GzipReader.new(gz).read
        rescue => e
          raise e, "URL[#{url}] #{e.message}"
        end

        Yajl::Parser.parse(js) do |event|
          event = Hashie::Mash.new(event)
          event_class = class_from_string("GitHubArchiveParser::#{event.type}")
          event_handler = @event_handlers[event_class]

          event_handler.each { |handler|
            if !handler.nil? && handler.respond_to?(:parse)
              handler.parse(event)
            end
          }
        end
      else
        raise "URL[#{url}] does not belong to http://data.githubarchive.org/"
      end
    end

    private

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
        @event_handlers[event_type] = event_type.descendants.map { |handler| handler.new }
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

  end
end
