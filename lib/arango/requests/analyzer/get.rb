module Arango
  module Requests
    module Analyzer
      class List < Arango::Request
        request_method :get

        self.uri_template = "/_api/analyzer/{name}"

        code 200, :success
        code 404, "Analyzer does not exist!"
      end
    end
  end
end
