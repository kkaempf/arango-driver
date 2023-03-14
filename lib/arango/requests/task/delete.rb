module Arango
  # Arango Requests
  module Requests
    # Task Requests
    module Task
      # API: DELETE /_api/tasks/{id}
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '/_api/tasks/{id}'

        code 200, :success
        code 404, "Task not found"
      end
    end
  end
end
