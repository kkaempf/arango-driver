module Arango
  # Arango Requests
  module Requests
    # Replication Requests
    module Replication
      # API: GET {/dbcontext}/_api/replication/dump
      class GetDump < Arango::Request
        self.request_method = :get

        self.uri_template = '{/dbcontext}/_api/replication/dump'

        param :collection, :required
        param :batch_id, :required
        param :chunk_size
        param :flush
        param :from
        param :include_system
        param :ticks
        param :to

        code 200, :success
        code 204, :success
        code 400, "From or to value is invalid!"
        code 404, "Collection could not be found!"
        code 405, "Invalid HTTP request method!"
        code 500, "A error occurred!"
      end
    end
  end
end
