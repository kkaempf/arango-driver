module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Graph
      class Create < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/gharial'

        param :wait_for_sync

        body :edge_definitions
        body :is_smart
        body :name
        body :options do
          key :number_of_shards
          key :replication_factor
          key :smart_graph_attribute
          key :write_concern
        end

        code 201, :success
        code 202, :success
        code 400, "Wrong request format!"
        code 403, "Permission denied!"
        code 409, "A graph with the given name is already stored or a edge definition conflict occured!"
      end
    end
  end
end
