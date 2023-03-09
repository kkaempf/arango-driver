module Arango
  module Requests
    module Analyzer
      class List < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/analyzer"

        code 200, :success
      end
    end
  end
end
