module Arango
  #
  # Arango User
  #
  class User
    include Arango::Helper::Satisfaction

    class << self
      # Retrieves all users.
      # @param server [Arango::Server]
      # @return [Array<Arango::User>]
      def all(server: Arango.current_server)
        result = Arango::Requests::User::List.execute(server: server)
        result.map { |u| self.new(server: server, **u) }
      end

      def create(name:, password: "", extra: {}, active: nil, server: Arango.current_server)
        self.new.create(server: server, password: password, extra: extra, active: active)
      end

      def get(name:, server: Arango.current_server)
        result = Arango::Requests::User::Get.execute(server: server, args: { user: name })
        self.new(server: server, **result)
      end

      def list(server: Arango.current_server)
        result = Arango::Requests::User::List.execcute(server: server)
        result.map { |u| u.name }
      end

      def drop(name:, server: Arango.current_server)
        Arango::Requests::User::Delete.exceute(server: server, args: { user: name })
      end

      def exists?(name:, server: Arango.current_server)
        !!Arango::Requests::User::Get.execute(server: server, args: { user: name })
      rescue
        false
      end
    end

    def initialize(server:, password: "", name:, extra: {}, active: nil)
      @server = server
      @password = password
      @name     = name
      @extra    = extra
      @active   = active
    end

    attr_accessor :name, :extra, :active
    attr_writer :password
    attr_reader :server

    def create
      body = {
        user: name,
        passwd: password,
        extra: extra,
        active: active
      }
      Arango::Requests::User::Create.new(server: server, body: body).execute
      self
    end

    def reload
      result = @server.request("GET", "_api/user/#{@name}", body: body)
      return_element(result)
    end

    def replace(password: @password, active: @active, extra: @extra)
      body = {
        passwd: password,
        active: active,
        extra: extra
      }
      result = @server.request("PUT", "_api/user/#{@name}", body: body)
      @password = password
      return_element(result)
    end

    def update(password: @password, active: @active, extra: @extra)
      body = {
        passwd: password,
        active: active,
        extra: extra
      }
      result = @server.request("PATCH", "_api/user/#{@name}", body: body)
      @password = password
      return_element(result)
    end

    def destroy
      result = @server.request("DELETE", "_api/user/#{@name}")
      return return_directly?(result) ? result : true
    end

  # == ACCESS ==

    def add_database_access(grant:, database:)
      satisfy_category?(grant, %w[rw ro none])
      satisfy_class_or_string?(database, Arango::Database)
      database = database.name if database.is_a?(Arango::Database)
      body = { grant: grant }
      result = @server.request("PUT", "_api/user/#{@name}/database/#{database}", body: body)
      return return_directly?(result) ? result : result[database.to_sym]
    end

    def grant(database:)
      add_database_access(grant: "rw", database: database)
    end

    def add_collection_access(grant:, database:, collection:)
      satisfy_category?(grant, %w[rw ro none])
      satisfy_class_or_string?(database, Arango::Database)
      satisfy_module_or_string?(collection, Arango::DocumentCollection::Mixin)
      database = database.name     if database.is_a?(Arango::Database)
      collection = collection.name if collection.is_a?(Arango::DocumentCollection)
      body = { grant: grant }
      result = @server.request("PUT", "_api/user/#{@name}/database/#{database}/#{collection}", body: body)
      return return_directly?(result) ? result : result[:"#{database}/#{collection}"]
    end

    def revoke_database_access(database:)
      satisfy_class_or_string?(database, Arango::Database)
      database = database.name if database.is_a?(Arango::Database)
      result = @server.request("DELETE", "_api/user/#{@name}/database/#{database}")
      return return_directly?(result) ? result : true
    end
    alias revoke revoke_database_access

    def revoke_collection_access(database:, collection:)
      satisfy_class_or_string?(database, Arango::Database)
      satisfy_module_or_string?(collection, Arango::DocumentCollection)
      database = database.name     if database.is_a?(Arango::Database)
      collection = collection.name if collection.is_a?(Arango::DocumentCollection)
      result = @server.request("DELETE", "_api/user/#{@name}/database/#{database}/#{collection}")
      return return_directly?(result) ? result : true
    end

    def list_access(full: nil)
      query = { full: full }
      result = @server.request("GET", "_api/user/#{@name}/database", query: query)
      return return_directly?(result) ? result : result[:result]
    end
    alias databases list_access

    def database_access(database:)
      satisfy_class_or_string?(database, Arango::Database)
      database = database.name if database.is_a?(Arango::Database)
      result = @server.request("GET", "_api/user/#{@name}/database/#{database}")
      return return_directly?(result) ? result : result[:result]
    end

    def collection_access(database:, collection:)
      satisfy_class_or_string?(database, Arango::Database)
      satisfy_module_or_string?(collection, Arango::DocumentCollection::Mixin)
      database = database.name     if database.is_a?(Arango::Database)
      collection = collection.name if collection.is_a?(Arango::DocumentCollection)
      result = @server.request("GET", "_api/user/#{@name}/database/#{database}/#{collection}", body: body)
      return return_directly?(result) ? result : result[:result]
    end
  end
end
