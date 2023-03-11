module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Replication
      class GetInventory < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/replication/inventory'

        param :batch_id, :required
        param :global
        param :include_system

        code 200, :success
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
      end
    end
  end
end
