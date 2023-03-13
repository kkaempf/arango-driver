module Arango
  # Arango Requests
  module Requests
    # Administration Requests
    module Administration
      # API: PUT /_api/tasks/{id}
      class CreateTaskId < Arango::Request
        self.request_method = :put

        self.uri_template = "/_api/tasks/{id}"

        body :command, :required
        body :name, :required
        body :offset, :required
        body :params
        body :period, :required

        code 200, :success
        code 400, "Task already exists or Body incorrect!"
      end
    end
  end
end
