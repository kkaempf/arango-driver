module Arango
  module Driver
    class Typhoeus
      def initialize(base_uri:, options:)
        @base_uri = base_uri
        username = options.delete(:username)
        password = options.delete(:password)
        @default_options = options.merge(userpwd: "#{username}:#{password}")
      end

      attr_accessor :base_uri, :default_options

      def execute_request(request_method, uri, headers, params, body)
        options = default_options.dup

        unless body.nil?
          body = Oj.dump(body, mode: :strict)
          options.merge!({ body: body })
        end

        options[:params] = params unless params.nil?

        unless headers.nil?
          options[:headers] = {} unless options.key?(:headers)
          options[:headers] = options[:headers].merge(headers)
        end
#        options[:verbose] = true
        begin
#          STDERR.puts "\n#{request_method} #{uri} #{options}"
          response = ::Typhoeus.send(request_method, uri, options)
        rescue Exception => e
          raise Arango::Error.new err: :impossible_to_connect_with_database, data: { error: e.message }
        end
#        STDERR.puts "\tresponse_body:#{response.response_body} return_code:#{response.return_code.inspect} response_code:#{response.response_code.inspect}"
        raise Arango::Error.new "Typhoeus curl error: #{response.response_code}" unless response.return_code == :ok
        response_body = response.response_body
        if headers && headers.key?("Content-Type") && headers["Content-Type"].start_with?("multipart/form-data")
          return response_body
        end

        begin
          json_result = unless response_body.empty?
                          Oj.load(response_body, mode: :json, symbol_keys: true)
                        else
                          {}
                        end
        rescue Exception => e
          raise Arango::Error.new err: :impossible_to_parse_arangodb_response,
            data: { response: response_body, request: JSON.pretty_generate(options) }
        end
#        STDERR.puts "json_result #{json_result.class}:#{json_result.inspect}"
        # json_result is an Array when multiple entries are involved
        if json_result.is_a?(Hash) && json_result[:error] == true
          raise Arango::Error.new(json_result[:errorMessage], err: json_result[:errorNum])
        end

        [json_result, response.response_code]
      end

      def download(url:, path:, body: {}, headers: {}, query: {})
        send_url = "#{@base_uri}/"
        send_url += url
        body.delete_if{|_,v| v.nil?}
        query.delete_if{|_,v| v.nil?}
        headers.delete_if{|_,v| v.nil?}
        body = Oj.dump(body, mode: :json)
        options = @default_options.merge({body: body, query: query, headers: headers, stream_body: true})
        File.open(path, "w") do |file|
          file.binmode
          Typhoeus.post(send_url, options) do |fragment|
            file.write(fragment)
          end
        end
      end
    end
  end
end
