module Arango
  module Requests
    module Index
      class Create < Arango::Request
        request_method :post

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
