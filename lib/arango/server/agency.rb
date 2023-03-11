module Arango
  # Arango Server
  class Server
    # Arango Server Agency
    module Agency
      def agency_config
        request("GET", "_api/agency/config")
      end

      def agency_write(body:, agency_mode: nil)
        satisfy_category?(agency_mode, ["waitForCommmitted", "waitForSequenced", "noWait", nil])
        headers = {"X-ArangoDB-Agency-Mode": agency_mode}
        request("POST", "_api/agency/write", headers: headers,
                body: body)
      end

      def agency_read(body:, agency_mode: nil)
        satisfy_category?(agency_mode, ["waitForCommmitted", "waitForSequenced", "noWait", nil])
        headers = {"X-ArangoDB-Agency-Mode": agency_mode}
        request("POST", "_api/agency/read", headers: headers,
                body: body)
      end
    end
  end
end
