module Arango
  # Arango Requests
  module Requests
  # Arango Requests
    module View
      class CreateSearchView < Arango::Request
        self.request_method = :post

        self.uri_template = '{/dbcontext}/_api/view#arangosearch'

        body :cleanup_interval_step
        body :commit_interval_msec
        body :consilidation_policy
        body :consolidation_interval_msec
        body :links
        body :name
        body :primary_sort
        body :type
        body :writebuffer_idle
        body :writebuffer_size_max

        code 200, :success
        code 400, "Name or type attribute missing or invalid!"
        code 409, "View name already exists!"
      end
    end
  end
end
