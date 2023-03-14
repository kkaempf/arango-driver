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

      # Create new user
      # @param name [String]
      # @param password [String]
      # @param extra
      # @param server [Arango::Server], defaults to {current_server}
      # @return [Arango::User]
      def create(name:, password: "", extra: {}, active: nil, server: Arango.current_server)
        self.new.create(server: server, password: password, extra: extra, active: active)
      end

      # Get user by name
      # @param name [String]
      # @param server [Arango::Server], defaults to {current_server}
      # @return [Arango::User]
      def get(name:, server: Arango.current_server)
        result = Arango::Requests::User::Get.execute(server: server, args: { user: name })
        self.new(server: server, **result)
      end

      # List users
      # # @param server [Arango::Server], defaults to {current_server}
      # @return [Array] of user names
      def list(server: Arango.current_server)
        result = Arango::Requests::User::List.execute(server: server)
        result.map { |u| u.name }
      end

      # Delete user by name
      # @param name [String]
      # @param server [Arango::Server], defaults to {current_server}
      # @return [Arango::Result]
      def drop(name:, server: Arango.current_server)
        Arango::Requests::User::Delete.execute(server: server, args: { user: name })
      end

      # Check if user exists
      # @param name [String]
      # @param server [Arango::Server], defaults to {current_server}
      # @return [Boolean]
      def exists?(name:, server: Arango.current_server)
        !!Arango::Requests::User::Get.execute(server: server, args: { user: name })
      rescue
        false
      end
    end

    attr_accessor :name, :extra, :active
    attr_writer :password
    attr_reader :server

    #
    # Replace user record
    #
    def replace(password: @password, active: @active, extra: @extra)
      body = {
        passwd: password,
        active: active,
        extra: extra
      }
      result = Arango::Requests::User::Replace.execute(body: body)
      @password = password
      return_element(result)
    end

    def update(password: @password, active: @active, extra: @extra)
      body = {
        passwd: password,
        active: active,
        extra: extra
      }
      result = Arango::Requests::User::Update.execute(body: body)
      @password = password
      return_element(result)
    end

    # Create new user
    def initialize(server:, password: "", name:, extra: {}, active: nil)
      @server = server
      @password = password
      @name     = name
      @extra    = extra
      @active   = active
    end

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

    # Grant access to database
    # @param grant [String] one of `rw`, `ro`, `none`
    # @param database [String] or [Arango::Database]
    # @return
    def add_database_access(grant:, database:)
      satisfy_category?(grant, %w[rw ro none])
      satisfy_class_or_string?(database, Arango::Database)
      database = database.name if database.is_a?(Arango::Database)
      body = { grant: grant }
      result = Arango::Requests::User::SetDatabaseAccessLevel.execute(user: self.name, database: database, body: body)
      return return_directly?(result) ? result : result[database.to_sym]
    end

    # Grant read-write access to database
    # @param database [String] or [Arango::Database]
    def grant(database:)
      add_database_access(grant: "rw", database: database)
    end

    # Grant access to database collection
    # @param grant [String] one of `rw`, `ro`, `none`
    # @param database [String] or [Arango::Database]
    # @param database [String] or [Arango::DocumentCollection]
    # @return
    def add_collection_access(grant:, database:, collection:)
      satisfy_category?(grant, %w[rw ro none])
      satisfy_class_or_string?(database, Arango::Database)
      satisfy_module_or_string?(collection, Arango::DocumentCollection::Mixin)
      database = database.name     if database.is_a?(Arango::Database)
      collection = collection.name if collection.is_a?(Arango::DocumentCollection)
      body = { grant: grant }
      result = Arango::Requests::User::SetCollectionAccessLevel.execute(user: self.name, database: database, collection: collection, body: body)
      return return_directly?(result) ? result : result[:"#{database}/#{collection}"]
    end

    # Revoke user access to database
    # @param database [String] or [Arango::Database]
    def revoke_database_access(database:)
      satisfy_class_or_string?(database, Arango::Database)
      database = database.name if database.is_a?(Arango::Database)
      result = Arango::Requests::User::ClearDatabaseAccessLevel.execute(user: self.name, database: database)
      return return_directly?(result) ? result : true
    end
    alias revoke revoke_database_access

    # Revoke user access to database collection
    # @param database [String] or [Arango::Database]
    # @param database [String] or [Arango::DocumentCollection]
    def revoke_collection_access(database:, collection:)
      satisfy_class_or_string?(database, Arango::Database)
      satisfy_module_or_string?(collection, Arango::DocumentCollection)
      database = database.name     if database.is_a?(Arango::Database)
      collection = collection.name if collection.is_a?(Arango::DocumentCollection)
      result = Arango::Requests::User::ClearCollectionAccessLevel.execute(user: self.name, database: database, collection: collection)
      return return_directly?(result) ? result : true
    end

    # List databases a user has access to
    # @param: full
    def list_access(full: nil)
      query = { full: full }
      result = Arango::Requests::User::ListDatabases.execute(body: query)
      return return_directly?(result) ? result : result[:result]
    end
    alias databases list_access

    # Get user access level for database
    # @param database [String] or [Arango::Database]
    def database_access(database:)
      satisfy_class_or_string?(database, Arango::Database)
      database = database.name if database.is_a?(Arango::Database)
      result = Arango::Requests::User::GetDatabaseAccessLevel.execute(name: self.name, database: database)
      return return_directly?(result) ? result : result[:result]
    end

    # Get user access level for database collection
    # @param database [String] or [Arango::Database]
    # @param database [String] or [Arango::DocumentCollection]
    def collection_access(database:, collection:)
      satisfy_class_or_string?(database, Arango::Database)
      satisfy_module_or_string?(collection, Arango::DocumentCollection::Mixin)
      database = database.name     if database.is_a?(Arango::Database)
      collection = collection.name if collection.is_a?(Arango::DocumentCollection)
      result = Arango::Requests::User::GetCollectionAccessLevel.execute(name: self.name, database: database, collection: collection)
      return return_directly?(result) ? result : result[:result]
    end
  end
end
