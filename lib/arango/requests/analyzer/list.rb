module Arango
  # Arango Requests
  module Requests
    # Analyzer Requests
    module Analyzer
      # API: /_api/analyzer
      class List < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/analyzer"

        code 200, :success
      end
    end
  end
end
