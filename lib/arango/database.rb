module Arango
  #
  # Arango Database
  #
  class Database
    include Arango::Helper::Satisfaction

    include Arango::Database::AQLFunctions
    include Arango::Database::Collections
    include Arango::Database::DocumentCollections
    include Arango::Database::EdgeCollections
    include Arango::Database::FoxxServices
    include Arango::Database::Graphs
    include Arango::Database::HTTPRoute
    include Arango::Database::AQLQueries
    include Arango::Database::AQLQueryCache
    include Arango::Database::Replication
    include Arango::Database::StreamTransactions
    include Arango::Database::Tasks
    include Arango::Database::Transactions
    include Arango::Database::ViewAccess

    class << self
      # Retrieves all databases.
      # @param server [Arango::Server]
      # @return [Array<Arango::Database>]
      def all(server:)
        list(server: server).map{ |db| Arango::Database.new(name: db, server: server).reload }
      end

      # Retrieves all databases the current user can access.
      # @param server [Arango::Server]
      # @return [Array<Arango::Database>]
      def all_user_databases(server:)
        list_user_databases(server: server).map{ |db| Arango::Database.new(name: db, server: server).reload }
      end

      # Create a new instance of self
      def create()
        self.new.create
      end
      
      # Get database from server.
      # @param name [String] The name of the database
      # @param server [Arango::Server]
      # @return [Arango::Database] The instance of the database.
      def get(name:, server:)
        Arango::Database.new(name: name, server: server).reload
      end

      # Retrieves a list of all databases.
      # @param server [Arango::Server]
      # @return [Array<String>] List of database names.
      def list(server:)
        result = Arango::Requests::Database::ListAll.execute(server: server).result        
      end

      # Retrieves a list of all databases the current user can access.
      # @param server [Arango::Server]
      # @return [Array<String>] List of database names.
      def list_user_databases(server:)
        result = Arango::Requests::Database::ListAccessible.execute(server: server).result
      end

      # Removes a database.
      # @param name [String] The name of the database
      # @param server [Arango::Server]
      # @return nil
      def delete(name:, server:)
        Arango::Requests::Database::Delete.execute(server: server, args: {name: name})
        nil
      end

      # Check if database exists.
      # @param name [String] Name of the database.
      # @param server [Arango::Server]
      # @return [Boolean]
      def exists?(name:, server:)
        list(server: server).include?(name)
      end
    end

    # Instantiate a new database. All params except name and server are optional.
    # @param name [String]
    # @param server [Arango::Server]
    # @param id
    # @param is_system
    # @param path
    # @return [Arango::Database]
    def initialize(name:, id: nil, is_system: false, path: '', server: Arango.current_server)
      send(:server=, server)
      @name = name
      @is_system = is_system
      @path = path
      @id = id
    end

    # Whether or not the current database is the _system database
    # @return [Boolean]
    attr_reader :is_system

    # The name of the database
    # @return [String]
    attr_reader :name

    # The filesystem path of the current database
    # @return [String]
    attr_reader :path

    attr_accessor :server

    # driver for database's server
    def driver_instance
      @server.driver_instance
    end

    # Creates the database on the server.
    # @return [Arango::Database] self
    def create
      # TODO users: users
      Arango::Requests::Database::Create.execute(server: self.server, body: { name: @name })
      self
    end

    # Reload database properties.
    # @return [Arango::Database] self
    def reload
      result = Arango::Requests::Database::GetInformation.execute(server: self.server, args: { db: @name })
      _update_attributes(result)
      self
    end

    # Remove database from the server.
    # @return nil
    def delete
      self.class.delete(name: @name, server: @arango_server)
      nil
    end

    # Returns the database version that this server requires.
    # @return [String]
    def target_version
      Arango::Requests::Administration::TargetVersion.execute(server: self.server).version
    end

    private

    def _update_attributes(result)
      %i[id isSystem name path].each do |key|
        instance_variable_set("@#{key.to_s.underscore}", result[key]) if result.key?(key)
      end
    end
  end
end
