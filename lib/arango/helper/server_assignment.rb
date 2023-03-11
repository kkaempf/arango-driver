module Arango
  # Arango Helper
  module Helper
    # Arango Helper ServerAssignment
    module ServerAssignment

      protected

      def assign_server(server)
        satisfy_class?(server, Arango::Server)
        @server = server
      end
    end
  end
end
