module Arango
  # Arango Requests
  module Requests
    # Analyzer Requests
    module Analyzer
      # API: GET /_api/analyzer/{name}
      class List < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/analyzer/{name}"

        code 200, :success
        code 404, "Analyzer does not exist!"
      end
    end
  end
end
