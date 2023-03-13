module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: GET /_api/tasks/{id}
      class GetTask < Arango::Request
        self.request_method = :get

        self.uri_template = "/_api/tasks/{id}"

        code 200, :success
        code 404, "Task not found!"
      end
    end
  end
end
