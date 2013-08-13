module BitBucket
  module Helpers
    module RepositoryHelper

      def sanitize_repository_name(repository_name)
        return nil if repository_name.nil?
        repository_name.downcase
          .gsub(/[^a-z0-9\_\-\.\/ ]/, '') # strip special characters
          .gsub(/[ \/]/, '-')             # convert characters to dashes
          .gsub(/-+/, '-')                # only allow one dash in a row
      end

    end
  end
end
