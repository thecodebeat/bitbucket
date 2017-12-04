require 'base64'
require 'faraday'
require 'forwardable'

module BitBucket
  module FaradayMiddleware
    class OAuth2 < Faraday::Middleware
      AUTH_HEADER = 'Authorization'.freeze

      attr_reader :oauth2_token

      extend Forwardable

      def call(env)
        if @oauth2_token.expired?
          @oauth2_token = @oauth2_token.refresh!({ headers: { 'Authorization' => 'Basic ' + get_api_key() } })
        end

        unless @oauth2_token.token.to_s.empty?
          env[:request_headers][AUTH_HEADER] = %(Bearer #{@oauth2_token.token})
        end

        @app.call env
      end

      def initialize(app = nil, token = nil)
        super app
        @oauth2_token = token
      end

    end
  end
end

Faraday::Request.register_middleware bitbucket_oauth2: BitBucket::FaradayMiddleware::OAuth2
