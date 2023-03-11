module Arango
  #
  # Arango Foxx
  #
  class Foxx
    include Arango::Helper::Satisfaction

    include Arango::Helper::DatabaseAssignment

    def initialize(database:, body: {}, mount:, development: nil, legacy: nil,
      provides: nil, name: nil, version: nil, type: "application/json",
      setup: nil, teardown: nil, cache_name: nil)
      assign_database(database)
      unless cache_name.nil?
        @cache_name = cache_name
        @server.cache.save(:foxx, cache_name, self)
      end
      assign_attributes(body)
      assign_type(type)
      @development ||= development
      @legacy      ||= legacy
      @mount       ||= mount
      @name        ||= name
      @provides    ||= provides
      @setup       ||= setup
      @teardown    ||= teardown
      @version     ||= version
    end

# === DEFINE ===

    attr_reader :body, :cache_name, :database, :server, :type
    attr_accessor :development, :legacy, :mount, :name, :provides, :setup, :teardown, :version

    def body=(result)
      if result.is_a?(Hash)
        @body        = result
        @development = result[:development] || @development
        @legacy      = result[:legacy]      || @legacy
        @mount       = result[:mount]       || @mount
        @name        = result[:name]        || @name
        @provides    = result[:provides]    || @provides
        @version     = result[:version]     || @version
        if @server.active_cache && @cache_name.nil?
          @cache_name = "#{@database.name}/#{@mount}"
          @server.cache.save(:task, @cache_name, self)
        end
      end
    end
    alias assign_attributes body=

    def type=(type)
      satisfy_category?(type, %w[application/zip zip application/javascript javascript application/json json multipart/form-data data])
      type = "application/#{type}" if %w[zip javascript json].include?(type)
      type = "multipart/form-data" if type == "data"
      @type = type
    end
    alias assign_type type=

# === TO HASH ===

    def to_h
      {
        cache_name: @cache_name,
        database: @database.name,
        development: @development,
        legacy: @legacy,
        mount: @mount,
        name: @name,
        provides: @provides,
        teardown: @teardown,
        type: @type,
        version: @version
      }.delete_if{|k,v| v.nil?}
    end

    def return_foxx(result, val=nil)
      return result if @server.async != false
      case val
      when :configuration
        @configuration = result
      when :dependencies
        @dependencies = result
      else
        assign_attributes(result)
      end
      return return_directly?(result) ? result : self
    end
    private :return_foxx

  # === ACTIONS ===

    def retrieve
      query = {mount: @mount}
      result = @database.request("GET", url: "_api/foxx/service")
      return_foxx(result)
    end

    def create(body: @body, type: @type, development: @development,
      setup: @setup, legacy: @legacy)
      headers = { Accept: type }
      skip_to_json = type != "application/json"
      query = {
        mount:        @mount,
        setup:        setup,
        development: development,
        legacy:       legacy
      }
      result = @database.request("POST",
        url: "_api/foxx", body: body, headers: headers,
        skip_to_json: skip_to_json, query: query)
      return_foxx(result)
    end

    def destroy(teardown: @teardown)
      query = {
        mount:    @mount,
        teardown: teardown
      }
      result = @database.request("DELETE", "_api/foxx/service", query: query)
      return_foxx(result)
    end

    def replace(body: @body, type: @type, teardown: @teardown, setup: @setup,
      legacy: @legacy)
      headers = { Accept: type }
      skip_to_json = type != "application/json"
      query = {
        mount:    @mount,
        setup:    setup,
        teardown: teardown,
        legacy:   legacy
      }
      result = @database.request("PUT", "_api/foxx/service", body: body,
        headers: headers, skip_to_json: skip_to_json, query: query)
      return_foxx(result)
    end

    def update(body: @body, type: @type, teardown: @teardown,
      setup: @setup, legacy: @legacy)
      assign_type(type)
      headers = { Accept: type }
      skip_to_json = @type != "application/json"
      query = {
        mount:        @mount,
        setup:        setup,
        teardown:     teardown,
        legacy:       legacy
      }
      result = @database.request("PATCH", "_api/foxx/service", body: body,
        headers: headers, skip_to_json: skip_to_json, query: query)
      return_foxx(result)
    end

  # === CONFIGURATION ===

    def retrieve_configuration
      query = { mount: @mount }
      result = @database.request("GET", "_api/foxx/configuration", query: query)
      return_foxx(result, :configuration)
    end

    def update_configuration(body:)
      query = { mount: @mount }
      result = @database.request("PATCH", "_api/foxx/configuration", query: query, body: body)
      return_foxx(result, :configuration)
    end

    def replace_configuration(body:)
      query = { mount: @mount }
      result = @database.request("PUT", "_api/foxx/configuration", query: query, body: body)
      return_foxx(result, :configuration)
    end

    # === DEPENDENCY ===

    def retrieve_dependencies
      query = { mount: @mount }
      result = @database.request("GET", "_api/foxx/dependencies", query: query)
      return_foxx(result, :dependencies)
    end

    def update_dependencies(body:)
      query = { mount: @mount }
      result = @database.request("PATCH", "_api/foxx/dependencies", query: query, body: body)
      return_foxx(result, :dependencies)
    end

    def replace_dependencies(body:)
      query = { mount: @mount }
      result = @database.request("PUT", "_api/foxx/dependencies", query: query, body: body)
      return_foxx(result, :dependencies)
    end

    # === MISCELLANEOUS

    def scripts
      query = { mount: @mount }
      @database.request("GET", "_api/foxx/scripts", query: query)
    end

    def run_script(name:, body: {})
      query = { mount: @mount }
      @database.request("POST", "_api/foxx/scripts/#{name}", query: query, body: body)
    end

    def tests(reporter: nil, idiomatic: nil)
      satisfy_category?(reporter, [nil, "default", "suite", "stream", "xunit", "tap"])
      headers = {}
      headers[:"Content-Type"] = case reporter
      when "stream"
        "application/x-ldjson"
      when "tap"
        "text/plain, text/*"
      when "xunit"
        "application/xml, text/xml"
      else
        nil
      end
      query = { mount: @mount }
      @database.request("GET", "_api/foxx/scripts", query: query, headers: headers)
    end

    def enable_development
      query = { mount: @mount }
      @database.request("POST", "_api/foxx/development", query: query)
    end

    def disable_development
      query = { mount: @mount }
      @database.request("DELETE", "_api/foxx/development", query: query)
    end

    def readme
      query = { mount: @mount }
      @database.request("GET", "_api/foxx/readme", query: query)
    end

    def swagger
      query = { mount: @mount }
      @database.request("GET", "_api/foxx/swagger", query: query)
    end

    def download(path:, warning: @server.warning)
      query = { mount: @mount }
      @server.download("POST", "_db/#{@database.name}/_api/foxx/download",
        path: path, query: query)
      puts "File saved in #{path}" if warning
    end

    def commit(body:, replace: nil)
      query = { replace: replace }
      @database.request("POST", "_api/foxx/commit", body: body, query: query)
    end
  end
end
