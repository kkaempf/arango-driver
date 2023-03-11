module Arango
  # Arango Server
  class Server
    # Arango Server Databases
    module Databases
      # Retrieves all databases.
      # @return [Array<Arango::Database>]
      def all_databases
        Arango::Database.all(server: self)
      end

      # Retrieves all databases the current user can access.
      # @return [Array<Arango::Database>]
      def all_user_databases
        Arango::Database.all_user_databases(server: self)
      end

      # Retrieves a list of all databases.
      # @return [Array<String>] List of database names.
      def list_databases
        Arango::Database.list(server: self)
      end

      # Retrieves a list of all databases the current user can access.
      # @return [Array<String>] List of database names.
      def list_user_databases
        Arango::Database.list_user_databases(server: self)
      end

      # Creates a new database.
      # @param name [String] The name of the database
      # @return [Arango::Database] The instance of the database created.
      def create_database(name:)
        Arango::Database.new(name: name, server: self).create
      end

      # Instantiates a new database, but does not store it on th server.
      # @param name [String] The name of the database
      # @return [Arango::Database] The instance of the database.
      def new_database(name:)
        Arango::Database.new(name: name, server: self)
      end

      # Removes a database.
      # @param name [String] The name of the database
      # @return nil
      def delete_database(name:)
        Arango::Database.delete(name: name, server: self)
      end

      # Get database from server.
      # @param name [String] The name of the database
      # @return [Arango::Database] The instance of the database.
      def get_database(name:)
        db = Arango::Database.get(name: name, server: self)
        self.current_database = db unless self.current_database
        db
      end

      # Check if database exists.
      # @param name [String] Name of the database.
      # @return [Boolean]
      def database_exists?(name:)
        Arango::Database.exists?(name: name, server: self)
      end
    end
  end
end
