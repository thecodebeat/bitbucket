# encoding: utf-8

module BitBucket #:nodoc
  # Raised when BitBucket receives a RefreshToken error
  module Error
    class RefreshToken < BitBucketError
      def initialize(env)
        super(env)
      end
    end
  end # Error
end # BitBucket
