module Arango
  module Requests
    module Bulk
      class Export < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/export"

        param :collection, :required

        body :batch_size
        body :count
        body :flush
        body :flush_wait
        body :limit
        body :restrict do
          key :fields
          key :type
        end
        body :ttl

        code 200, :success
        code 400, "JSON representation is malformed or the query specification is missing!"
        code 404, "Collection does not exist!"
        code 405, "Invalid HTTP method!"
        code 501, "Cannot be executed on cluster coordinator!"
      end
    end
  end
end
