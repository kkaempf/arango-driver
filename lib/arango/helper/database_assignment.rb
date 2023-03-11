module Arango
  # Arango Helper
  module Helper
    # Arango Helper DatabaseAssignment
    module DatabaseAssignment

      protected

      def assign_database(database)
        satisfy_class?(database, Arango::Database)
        @database = database
        @server = @database.server
      end
    end
  end
end
