module Arango
  # Arango Requests
  module Requests
    # Analyzer Requests
    module Analyzer
      # API: POST /_api/analyzer
      class Create < Arango::Request
        self.request_method = :post

        self.uri_template = "/_api/analyzer"

        body :features
        body :name
        body :properties
        body :type

        code 200, :success
        code 201, :success
        code 400, "Parameter missing or not valid!"
        code 403, "Permission denied!"
      end
    end
  end
end
