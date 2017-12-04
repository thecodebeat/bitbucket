# encoding: utf-8

require 'faraday'
require 'faraday_middleware'
require 'bitbucket_rest_api/response'
require 'bitbucket_rest_api/response/mashify'
require 'bitbucket_rest_api/response/jsonize'
require 'bitbucket_rest_api/response/raise_error'
require 'bitbucket_rest_api/request/basic_auth'
require 'bitbucket_rest_api/request/jsonize'
require 'bitbucket_rest_api/request/oauth2'
require 'oauth2'

module BitBucket
  module Connection
    extend self
    include BitBucket::Constants

    ALLOWED_OPTIONS = [
        :headers,
        :url,
        :params,
        :request,
        :ssl
    ].freeze

    def default_options(options={})
      {
          :headers => {
              USER_AGENT       => user_agent
          },
          :ssl => { :verify => false },
          :url => options.fetch(:endpoint) { BitBucket.endpoint }
      }.merge(BitBucket.connection_options)
      .merge(options)
    end

    # Default middleware stack that uses default adapter as specified at
    # configuration stage.
    #
    def default_middleware(options={})
      Proc.new do |builder|
        #builder.use BitBucket::Request::Jsonize
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded

        if client_id? && client_secret?
          builder.use BitBucket::FaradayMiddleware::OAuth2, {client_id: client_id, client_secret: client_secret, connection_options: BitBucket.connection_options}
        end

        builder.use BitBucket::Request::BasicAuth, authentication if basic_authed?
        builder.use ::FaradayMiddleware::EncodeJson

        builder.use ::Faraday::Response::Logger if ENV['DEBUG']
        unless options[:raw]
          builder.use BitBucket::Response::Mashify
          builder.use BitBucket::Response::Jsonize
        end
        builder.use BitBucket::Response::RaiseError
        builder.adapter adapter
      end
    end

    @connection = nil

    @stack = nil

    def clear_cache
      @connection = nil
    end

    def caching?
      !@connection.nil?
    end

    # Exposes middleware builder to facilitate custom stacks and easy
    # addition of new extensions such as cache adapter.
    #
    def stack(options={}, &block)
      @stack ||= begin
        if block_given?
          Faraday::RackBuilder.new(&block)
        else
          Faraday::RackBuilder.new(&default_middleware(options))
        end
      end
    end

    # Returns a Fraday::Connection object
    #
    def connection(options = {})
      conn_options = default_options(options)
      clear_cache unless options.empty?
      puts "OPTIONS:#{conn_options.inspect}" if ENV['DEBUG']

      @connection ||= Faraday.new(conn_options.merge(:builder => stack(options))) do |faraday|
        faraday.response :logger if ENV['DEBUG']
      end
    end

  end # Connection
end # BitBucket
