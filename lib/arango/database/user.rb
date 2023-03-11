module Arango
  # Arango Database
  class Database
    # Arango Database User
    module User
      def check_user(user)
        user = Arango::User.new(user: user) if user.is_a?(String)
        return user
      end
      private :check_user

      def add_user_access(grant:, user:)
        user = check_user(user)
        user.add_database_access(grant: grant, database: @name)
      end

      def revoke_user_access(user:)
        user = check_user(user)
        user.revoke_database_access(database: @name)
      end

      def user_access(user:)
        user = check_user(user)
        user.database_access(database: @name)
      end
    end
  end
end
