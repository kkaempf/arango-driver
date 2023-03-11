module Arango
  # Arango Database
  class Database
    # Arango Database Replication
    module Replication
      # === REPLICATION ===

      def inventory(batch_id:, global: nil, include_system: nil)
        query = {
          batchId: batch_id,
          global: global,
          includeSystem: include_system
        }
        request("GET", "_api/replication/inventory", query: query)
      end

      def cluster_inventory(include_system: nil)
        query = { includeSystem: include_system }
        request("GET", "_api/replication/clusterInventory", query: query)
      end

      def logger
        request("GET", "_api/replication/logger-state")
      end

      def logger_follow(from: nil, to: nil, chunk_size: nil, include_system: nil)
        query = {
          from: from,
          to:   to,
          chunkSize:     chunk_size,
          includeSystem: include_system
        }
        request("GET", "_api/replication/logger-follow", query: query)
      end

      def logger_first_tick
        request("GET", "_api/replication/logger-first-tick", key: :firstTick)
      end

      def logger_range_tick
        request("GET", "_api/replication/logger-tick-ranges")
      end

      def server_id
        request("GET", "_api/replication/server-id", key: :serverId)
      end

      def range
        request("GET", "_api/wal/range")
      end

      def last_tick
        request("GET", "_api/wal/lastTick")
      end

      def tail(from: nil, to: nil, global: nil, chunk_size: nil,
               server_id: nil, barrier_id: nil)
        query = {
          from: from,
          to: to,
          barrierID: barrier_id,
          chunkSize: chunk_size,
          global: global,
          serverID: server_id,
        }
        request("GET", "_api/wal/tail", query: query)
      end

      def replication(master:, adaptive_polling: nil, auto_resync: nil, auto_resync_retries: nil, chunk_size: nil, connect_timeout: nil,
                      connection_retry_wait_time: nil, idle_max_wait_time: nil, idle_min_wait_time: nil, include_system: true, incremental: nil,
                      initial_sync_max_wait_time: nil, max_connect_retries: nil, request_timeout: nil, require_from_present: nil,
                      restrict_collections: nil, restrict_type: nil, verbose: nil)
        Arango::Replication.new(slave: self, master: master, adaptive_polling: adaptive_polling, auto_resync: auto_resync,
                                auto_resync_retries: auto_resync_retries, chunk_size: chunk_size, connect_timeout: connect_timeout,
                                connection_retry_wait_time: connection_retry_wait_time, idle_max_wait_time: idle_max_wait_time,
                                idle_min_wait_time: idle_min_wait_time, include_system: include_system, incremental: incremental,
                                initial_sync_max_wait_time: initial_sync_max_wait_time, max_connect_retries: max_connect_retries,
                                request_timeout: request_timeout, require_from_present: require_from_present,
                                restrict_collections: restrict_collections, restrict_type: restrict_type, verbose: verbose)
      end

      def replication_as_master(slave:, adaptive_polling: nil, auto_resync: nil, auto_resync_retries: nil, chunk_size: nil, connect_timeout: nil,
                                connection_retry_wait_time: nil, idle_max_wait_time: nil, idle_min_wait_time: nil, include_system: true,
                                incremental: nil, initial_sync_max_wait_time: nil, max_connect_retries: nil, request_timeout: nil,
                                require_from_present: nil, restrict_collections: nil, restrict_type: nil, verbose: nil)
        Arango::Replication.new(master: self, slave: slave, adaptive_polling: adaptive_polling, auto_resync: auto_resync,
                                auto_resync_retries: auto_resync_retries, chunk_size: chunk_size, connect_timeout: connect_timeout,
                                connection_retry_wait_time: connection_retry_wait_time, idle_max_wait_time: idle_max_wait_time,
                                idle_min_wait_time: idle_min_wait_time, include_system: include_system, incremental: incremental,
                                initial_sync_max_wait_time: initial_sync_max_wait_time, max_connect_retries: max_connect_retries,
                                request_timeout: request_timeout, require_from_present: require_from_present,
                                restrict_collections: restrict_collections, restrict_type: restrict_type, verbose: verbose)
      end


    end
  end
end
