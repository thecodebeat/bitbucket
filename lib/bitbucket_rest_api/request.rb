# encoding: utf-8

module BitBucket
  # Defines HTTP verbs
  module Request

    METHODS = [:get, :post, :put, :delete, :patch]
    METHODS_WITH_BODIES = [ :post, :put, :patch ]

    def get_request(path, params={}, options={})
      request(:get, path, params, options)
    end


    def patch_request(path, params={}, options={})
      request(:patch, path, params, options)
    end

    def post_request(path, params={}, options={})
      request(:post, path, params, options)
    end

    def put_request(path, params={}, options={})
      request(:put, path, params, options)
    end

    def delete_request(path, params={}, options={})
      request(:delete, path, params, options)
    end

    def retry_token_refresh_errors
      count = 0
      begin
        yield
      rescue BitBucket::Error::RefreshToken
        count += 1
        if count <= 3
          sleep 0.3 * count
          retry
        end
        raise
      end
    end

    def request(method, path, params, options={})
      if !METHODS.include?(method)
        raise ArgumentError, "unkown http method: #{method}"
      end
      # _extract_mime_type(params, options)

      puts "EXECUTED: #{method} - #{path} with #{params} and #{options}" if ENV['DEBUG']

      response = retry_token_refresh_errors do
        conn = connection(options)
        prefix = path_prefix(path, conn)
        path = (prefix + path).gsub(/\/\//,'/') if conn.path_prefix != '/'

        response = conn.send(method) do |request|
          request['Authorization'] = "Bearer #{new_access_token}" unless new_access_token.nil?
          case method.to_sym
          when *(METHODS - METHODS_WITH_BODIES)
            request.body = params.delete('data') if params.has_key?('data')
            request.url(path, params)
          when *METHODS_WITH_BODIES
            request.path = path
            unless params.empty?
              # data = extract_data_from_params(params)
              # request.body = MultiJson.dump(data)
              request.body = MultiJson.dump(params)
            end
          end
        end
      end

      response.body
    end

    private

    def path_prefix(path, conn)
      if path.include?('/ssh') && BitBucket.options[:bitbucket_server]
        '/rest/keys'
      elsif path.include?('/build-status') && BitBucket.options[:bitbucket_server]
        ''
      else
        conn.path_prefix
      end
    end

    # def extract_data_from_params(params) # :nodoc:
    #   if params.has_key?('data') and !params['data'].nil?
    #     params['data']
    #   else
    #     params
    #   end
    # end

    def _extract_mime_type(params, options) # :nodoc:
      options['resource']  = params['resource'] ? params.delete('resource') : ''
      options['mime_type'] = params['resource'] ? params.delete('mime_type') : ''
    end

  end # Request
end # BitBucket
