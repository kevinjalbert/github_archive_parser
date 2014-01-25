require 'github_archive_parser/initialize'

module GitHubArchiveParser
  class CLI
    attr_reader :options

    def initialize
      @options = OpenStruct.new(
        debug: false,
        quite: false,
        since: nil,
        until: nil,
      )
      parse_options
      determine_log_level
    end

    def process(args)
      processor = Processor.new
      begin
        if !@options.until.nil?
          processor.process_between(@options.since, @options.until)
        elsif !@options.since.nil?
          processor.process_since(@options.since)
        else
          args.each {|url| processor.process_url(url) }
        end
      rescue Exception => e
        Log.error e
      end
    end

    private

    def parse_options
      OptionParser.new do |opt|
        opt.version = VERSION
        opt.on "-d", "--debug", "Debug output (shows DEBUG level log statements)" do
          options.debug = true
        end
        opt.on "-q", "--quite", "Hide all output (shows only UNKNOWN level log statements)" do
          options.quite = true
        end
        opt.on "-s", "--since TIME", "Process all events since the provided date (can be specified in natural language)" do |time|
          options.since = time
        end
        opt.on "-u", "--until TIME", "Process all events until the provided date (can be specified in natural language) starting from February 12, 2011" do |time|
          options.until = time
        end
      end.parse!
    end

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

  end
end
