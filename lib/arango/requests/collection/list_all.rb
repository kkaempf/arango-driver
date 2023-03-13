module Arango
  # Arango Requests
  module Requests
    # Collection Requests
    module Collection
      # API: GET /_api/collection
      class ListAll < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/collection"

        param :exclude_system

        code 200, :success
      end
    end
  end
end
