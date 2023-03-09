module Arango
  module Requests
    module Administration
      class DeleteTasks < Arango::Request
        self.request_method = :delete

        self.uri_template = "/_api/tasks/{id}"

        code 200, :success
        code 404, "Task is unknown!"
      end
    end
  end
end
