module Arango
  # Arango Server
  class Server
    # Arango Server Monitoring
    module Monitoring
      # === MONITORING ===

      def cluster_health
        request("GET", "_admin/health")
      end

      def cluster_statistics dbserver:
        query = {DBserver: dbserver}
        request("GET", "_admin/clusterStatistics", query: query)
      end

    end
  end
end
