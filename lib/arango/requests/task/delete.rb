module Arango
  module Requests
    module Task
      class Delete < Arango::Request
        self.request_method = :delete

        self.uri_template = '/_api/tasks/{id}'

        code 200, :success
        code 404, "Task not found"
      end
    end
  end
end
