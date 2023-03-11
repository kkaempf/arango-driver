module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Analyzer
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/analyzer/{name}"

        param :force

        code 200, :success
        code 400, "Analyzer name missing or invalid paramater!"
        code 403, "Permission denied!"
        code 404, "Analyzer does not exist!"
        code 409, "Analyzer is still being used!"
      end
    end
  end
end
