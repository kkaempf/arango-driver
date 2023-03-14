module Arango
  # Arango Requests
  module Requests
    # Index Requests
    module Index
      # API: POST {/dbcontext}/_api/index
      class Create < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/index'

        param :collection, :required

        body :deduplicate
        body :fields
        body :inBackground
        body :sparse
        body :type, :required
        body :unique

        code 200, :success
        code 201, :success
        code 400, "Documents violating uniqueness!"
        code 404, "Collection unknown!"
      end
    end
  end
end
