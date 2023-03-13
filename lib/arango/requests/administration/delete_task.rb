module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: DELETE /_api/tasks/{id}
      class DeleteTasks < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/tasks/{id}"

        code 200, :success
        code 404, "Task is unknown!"
      end
    end
  end
end
