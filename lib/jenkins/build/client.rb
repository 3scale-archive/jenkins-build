require 'uri'
require 'json'

module Jenkins
  module Build
    class Client
      def initialize(configuration)
        @configuration = configuration

        @base_uri = URI(@configuration.server).freeze

        @connection = Net::HTTP.new(@base_uri.host, @base_uri.port)
        @connection.use_ssl = (@base_uri.scheme == 'https')

        @connection
      end

      def trigger(branch)
        response = post("/job/#{@configuration.project}/build", parameter: { name: :sha1, value: branch })
        case response
          when Net::HTTPCreated then true
          else
            raise InvalidResponse, response
        end
      end

      private

      class InvalidResponse < StandardError
        attr_reader :code, :message

        def initialize(response)
          @code = response.code
          @message = response.message
          @response = response
          super("Unexpected HTTP Response: #{@message}")
        end
      end

      def post(path, params)
        uri = URI.join(@base_uri, path)
        body = JSON.generate(params)

        post = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        post.set_form_data json: body

        request(post)
      end

      def request(request)
        request.basic_auth(@configuration.user, @configuration.api_key)

        case response = @connection.request(request)
          when Net::HTTPSuccess then return response
          else raise InvalidResponse, response
        end
      end
    end
  end
end
