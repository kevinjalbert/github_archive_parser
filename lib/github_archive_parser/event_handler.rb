module GitHubArchiveParser
  class EventHandler
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def parse
      raise "method is not defined for #{self.class}"
    end
  end
end
