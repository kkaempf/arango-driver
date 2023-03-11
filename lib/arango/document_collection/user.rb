module Arango
  # Arango DocumentCollection
  module DocumentCollection
    # Arango DocumentCollection User
    module User
      # === USER ACCESS ===

      def check_user(user)
        user = Arango::User.new(user: user) if user.is_a?(String)
        return user
      end
      private :check_user

      def add_user_access(grant:, user:)
        user = check_user(user)
        user.add_collection_access(grant: grant, database: @database.name, collection: @name)
      end

      def revoke_user_access(user:)
        user = check_user(user)
        user.clear_collection_access(database: @database.name, collection: @name)
      end

      def user_access(user:)
        user = check_user(user)
        user.collection_access(database: @database.name, collection: @name)
      end
    end
  end
end
