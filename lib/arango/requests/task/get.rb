module Arango
  # Arango Requests
  module Requests
    # Task Requests
    module Task
      # API: GET /_api/tasks/{id}
      class Get < Arango::Request
        self.request_method = :get

        self.uri_template = '/_api/tasks/{id}'

        code 200, :success
        code 404, "Task #{@id} not found"
      end
    end
  end
end
