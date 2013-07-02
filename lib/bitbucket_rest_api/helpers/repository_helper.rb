module BitBucket
  module Helpers
    module RepositoryHelper

      module ClassMethods
      end

      module InstanceMethods
        def sanitize_repository_name(repository_name)
          repository_name.downcase.gsub(/[^a-z0-9\_\-\. ]/, '').gsub(' ', '-')
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end

    end
  end
end
