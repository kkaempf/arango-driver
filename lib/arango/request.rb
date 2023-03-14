require "addressable/template"
module Arango
  #
  # Arango Request
  # Implements REST API to Arango
  # Used to define accessor classes to run `execute`
  # Strictly internal. Not user accessible. Used to implement REST API representation classes.
  #
  class Request
    class << self
      # execute Arango::Request
      # @return [Arango::Result]
      def execute(**args)
        self.new(**args).execute
      end

      # check if body exists
      # @return [Boolean]
      def has_body?
        @has_body
      end

      # check if body is an Array
      # @return [Boolean]
      def body_is_array?
        @body_is_array
      end

      # get body keys
      # sets @body_keys to empty Hash (if unset)
      # @return [Hash]
      def body_keys
        @body_keys ||= Hash.new
      end

      # define body element
      # @param name [String]
      # @param option [Symbol] `:required` or `:optional`, defaults to `nil`
      def body(name, option = nil, &block)
        @has_body = true
        camel_name = name.to_s.camelize(:lower)
        case option
        when :required then body_keys[name] = { camel: camel_name, required: true }
        when :optional then body_keys[name] = { camel: camel_name }
        when nil then body_keys[name] = { camel: camel_name }
        else
          raise Arango::Error.new("Unknown option '#{option}'!")
        end
        if block_given?
          @current_nested_body = Hash.new
          block.call
          body_keys[name][:nested] = @current_nested_body
        end
      ensure
        @current_nested_body = nil
      end

      # make body an Array
      def body_array
        body_any
        @body_is_array = true
      end

      # allow any body content
      def body_any
        @has_body = true
        @body_any_key_allowed = true
      end

      # allow any body keys
      def body_any_key_allowed
        @body_any_key_allowed
      end

      # define body key
      # @param name [String]
      # @param option [Symbol] `:required` or `:optional`, defaults to `nil`
      def key(name, option = nil)
        raise Arango::Error.new("No body context!") unless @current_nested_body
        camel_name = name.to_s.camelize(:lower)
        value = case option
                when :required then { camel: camel_name, required: true }
                when :optional then { camel: camel_name }
                when nil then { camel: camel_name }
                else
                  raise Arango::Error.new("Unknown option '#{option}'!")
                end
        @current_nested_body[name] = value
      end

      # if request has a header defined
      # @return [Boolean]
      def has_header?
        @has_header
      end

      # get defined headers
      # sets headers to empty Hash if undefined
      # @return [Hash]
      def headers
        @headers ||= Hash.new
      end

      # define header element
      # @param name [String]
      # @param option [Symbol] `:required` or `:optional`, defaults to `nil`
      def header(name, option = nil)
        @has_header = true
        key = name.underscore.downcase.to_sym
        case option
        when :required then headers[key] = { real: name, required: true }
        when :optional then headers[key] = { real: name }
        when nil then headers[key] = { real: name }
        else
          raise Arango::Error.new("Unknown option #{option}")
        end
      end

      # parameters defined ?
      # @return [Boolean]
      def has_param?
        @has_param
      end

      # get defined parameters
      # sets parameters to empty Hash if undefined
      # @return [Hash]
      def params
        @params ||= Hash.new
      end

      # define parameter element
      # @param name [String]
      # @param option [Symbol] `:required` or `:optional`, defaults to `nil`
      def param(name, option = nil)
        @has_param = true
        camel_name = name.to_s.camelize(:lower)
        case option
        when :required then params[name] = { camel: camel_name, required: true }
        when :optional then params[name] = { camel: camel_name }
        when nil then params[name] = { camel: camel_name }
        else
          raise Arango::Error.new("Unknown option #{option}")
        end
      end

      # define request method
      # @param name [String] http request method (:GET, :PUT, :POST, :PATCH, :DELETE)
      def request_method= name
        @request_method = name
      end

      # get request method
      def reqm
        @request_method
      end

      # define uri template for API call
      # @param template [String]
      # see https://rubydoc.info/gems/addressable/Addressable/Template
      def uri_template= template
        @uri_template = Addressable::Template.new(template)
      end

      # get uri template
      def uri_template
        @uri_template
      end

      # get known http return codes and their meanings
      # sets codes to empty hash if undefined
      # @return [Hash]
      def codes
        @codes ||= {}
      end

      # define known http code and its meaning
      # @param number [Integer]
      # @param message [String]
      def code(number, message)
        codes[number] = message
      end
    end

    attr_reader :args
    attr_reader :database
    attr_reader :formatted_headers
    attr_reader :formatted_params
    attr_reader :formatted_body
    attr_reader :server

    # create expanded URI, (from template, including keys) and http:// prefix
    def formatted_uri
      hash = {}
      hash['db_context'] = ['_db', database] if database
      hash.merge!(args.transform_keys(&:to_s)) if args
      server.driver_instance.base_uri + self.class.uri_template.expand(hash)
    end

    # create Arango::Request instance
    # @param body [Hash] optional
    # @param params [Hash] optional
    # @param headers [Hash] optional
    # @param args [Hash] optional
    # @param server [Arango::Server] use to target correct server (and driver)
    def initialize(body: nil, params: {}, headers: nil, args: nil, server:)
      @server = server
      if args
        @database = args.delete(:db)
        @args = args
      end
      @formatted_headers = validate_and_format_header!(headers) if self.class.has_header?
      @formatted_params = validate_and_format_params!(params) if self.class.has_param?
      @formatted_body = if self.class.body_is_array? || self.class.body_any_key_allowed
                          body
                        elsif self.class.has_body?
                          validate_and_format_body!(body)
                        end
    end

    # execute request
    # @return [Arango::Result]
    # @raise [Arango::Error]
    def execute
      response, response_code = server.driver_instance.execute_request(self.class.reqm, formatted_uri, formatted_headers, formatted_params, formatted_body)

      if self.class.codes.key?(response_code)
        raise Arango::Error.new(self.class.codes[response_code]) unless self.class.codes[response_code] == :success
      else
        raise Arango::Error.new("Unknown response code #{response_code}")
      end

      begin
        response[:code] = response_code
      rescue TypeError
        # response might be an Array
      end

      result = Arango::Result.new(response)

      # block ? block.call(result) : result
      result
    end

    private

    # validate header according to defined header elements
    def validate_and_format_header!(headers)
      result = {}
      headers ||= {} #raise Arango::Error.new("No headers given!") unless headers
      self.class.headers.each do |header, options|
        value = nil
        exists = headers.has_key? header
        unless exists
          header = options[:real]
          exists = headers.has_key? header
          unless exists
            header = options[:real].to_sym
            exists = headers.has_key? header
          end
        end
        value = headers.delete(header) if exists
        raise Arango::Error.new("Required header '#{header}' not given or nil!") if options.key?(:required) && value.nil?
        next unless exists
        raise Arango::Error.new("Given header '#{header}' cannot be nil!") if value.nil?
        result[options[:real]] = value
      end
      raise Arango::Error.new "Unknown headers #{headers}!" unless headers.empty?
      result
    end

    # validate parameters according to defined parameters
    def validate_and_format_params!(params)
      result = {}
      params ||= {} #raise Arango::Error.new("No params given!") unless params
      self.class.params.each do |param, options|
        value = nil
        sym = param.to_sym
        exists = params.has_key? sym
        if exists
          value = params.delete(sym)
        else
          camel = options[:camel]
          sym = camel.to_sym
          exists = params.has_key? sym
          if exists
            value = params.delete(sym)
            param = camel
          end
        end
        raise Arango::Error.new("Required param '#{param}' not given or nil!") if options.key?(:required) && value.nil?
        raise Arango::Error.new("Given param '#{param}' must not be nil!") if exists && value.nil?
        result[options[:camel]] = value if exists
      end
      raise Arango::Error.new("Unknown params passed #{params}!") unless params.empty?
      result
    end

    # validate body according to defined body keys
    def validate_and_format_body!(body)
      result = {}
      body ||= {}
      self.class.body_keys.each do |key, options|
        has_key = body.key?(key)
        unless has_key
          key = options[:camel].to_sym
          has_key = body.key?(key)
        end
        raise Arango::Error.new("Required body key '#{key}' not given!") if options.key?(:required) && !has_key
        if has_key
          result[options[:camel]] = if options.key?(:nested)
                                      nested = body.delete(key)
                                      validate_and_format_nested!(nested, key, options[:nested])
                                    else
                                      body.delete(key)
                                    end
        end
      end
      if self.class.body_any_key_allowed
        body.each_key do |key|
          case key
          when :_key, :_id, :_rev
            result[key] = body.delete(key)
          else
            result[key.to_s.camelize(:lower)] = body.delete(key)
          end
        end
      elsif body.any?
        raise Arango::Error.new("Unknown body keys passed #{body.keys}!")
      end
      result
    end

    # validate nested body
    def validate_and_format_nested!(nested_body, body_key, nested_keys)
      result = {}
      nested_keys.each do |key, options|
        has_key = nested_body.key?(key)
        raise Arango::Error.new("Required nested body key '#{key}' for body key '#{body_key}' not given!") if options.key?(:required) && !has_key
        result[options[:camel]] = nested_body.delete(key) if has_key
      end
      result
    end
  end
end
