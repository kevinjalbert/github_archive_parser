require 'github_archive_parser/initialize'

module GitHubArchiveParser
  class CLI
    attr_reader :options

    def initialize
      @options = OpenStruct.new(
        debug: false,
        quite: false,
      )
      parse_options
      determine_log_level
    end

    def process(args)
      processor = Processor.new
      begin
        args.each {|url| processor.process_url(url) }
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
