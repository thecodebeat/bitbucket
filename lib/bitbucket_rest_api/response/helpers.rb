# encoding: utf-8

require 'faraday'

module BitBucket
  class Response::Helpers < Response

    def on_complete(env)
      env[:body].extend BitBucket::Result
      env[:body].define_singleton_method(:env) { env }
    end

  end # Response::Helpers
end # BitBucket
