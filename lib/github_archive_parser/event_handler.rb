module GitHubArchiveParser
  module EventHandler
    module ClassMethods
      def descendants
        @descendants ||= ObjectSpace.each_object(Class).select { |klass| klass < self }
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
