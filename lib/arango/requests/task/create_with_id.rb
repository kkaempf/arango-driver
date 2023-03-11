module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module Task
      class CreateWithId < Arango::Request
        self.request_method = :put

        self.uri_template = '/_api/tasks/{id}'

        body :name, :required
        body :command, :required
        body :params, :required
        body :period
        body :offset

        code 200, :success
        code 400, "Task name, command, or params is missing"
        code 409, "duplicate task id"
      end
    end
  end
end
