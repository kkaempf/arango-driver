module Arango
  # Arango Server
  class Server
    # Arango Server User
    module User
      # Retrieves all users.
      # @return [Array<Arango::User>]
      def all_users
        Arango::User.all(server: self)
      end

      # Retrieves a list of all users.
      # @return [Array<String>] List of user names.
      def list_users
        Arango::User.list(server: self)
      end

      # Creates a new user.
      # @param name [String] The name of the user
      # @return [Arango::User] The instance of the user created.
      def create_user(password: "", name:, extra: {}, active: nil)
        Arango::User.create(server: self, password: password, name: name, extra: extra, active: active)
      end

      # Removes a user.
      # @param name [String] The name of the user
      # @return nil
      def drop_user(name:)
        Arango::User.drop(name: name)
      end

      # Get user from server.
      # @param name [String] The name of the user
      # @return [Arango::user] The instance of the user.
      def get_user(name:)
        Arango::User.get(name: name)
      end

      # Check if user exists.
      # @param name [String] Name of the user.
      # @return [Boolean]
      def user_exists?(name:)
        Arango::User.exists?(name: name)
      end
    end
  end
end
