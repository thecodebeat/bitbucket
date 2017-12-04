require 'base64'
require 'faraday'
require 'forwardable'

module BitBucket
  module FaradayMiddleware
    class OAuth2 < Faraday::Middleware
      AUTH_HEADER = 'Authorization'.freeze

      attr_reader :options

      extend Forwardable

      def call(env)
        reset_oauth2_token! if oauth2_token.expired?

        unless oauth2_token.token.to_s.empty?
          env[:request_headers][AUTH_HEADER] = %(Bearer #{oauth2_token.token})
        end

        @app.call env
      end

      def initialize(app, options={})
        super app
        @options = options
      end

      private

      def reset_oauth2_token!
        @token = nil
      end

      def oauth2_token
        @token ||= oauth2_client.client_credentials.get_token
      end

      def oauth2_client
        oauth2_client ||= ::OAuth2::Client.new(
          options[:client_id],
          options[:client_secret],
          site: 'https://bitbucket.org',
          authorize_url: '/site/oauth/authorize',
          token_url: '/site/oauth2/access_token',
          connection_opts: options[:connection_options]
        )
      end

    end
  end
end

Faraday::Request.register_middleware bitbucket_oauth2: BitBucket::FaradayMiddleware::OAuth2
