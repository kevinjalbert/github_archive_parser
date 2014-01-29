module GitHubArchiveParser
  module Utilities
    module_function

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

    def time_from_natural_language(natural_language)
      time = Chronic.parse(natural_language)
      raise "Invalid time: #{natural_language}" if time.nil?
      time.getutc
    end
  end
end
