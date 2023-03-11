module Arango
  #
  # Arango Server
  #
  class Server
    # Arango Server Administration
    module Administration
      # Check availability of the server.
      # @return [Boolean]
      def available?
        200 == Arango::Requests::Administration::Availability.execute(server: self).response_code
      end

      # Returns information about all coordinator endpoints (cluster only).
      # @return [Array<String>]
      def cluster_endpoints
        if in_cluster?
          result = Arango::Requests::Administration::ClusterEndpoints.execute(server: self)
          result.endpoints.map { |e| e[:endpoint] }
        end
      end

      # Returns information about all server endpoints.
      # @return [Array<String>]
      def endpoints
        result = Arango::Requests::Administration::Endpoints.execute(server: self)
        result.map { |e| e[:endpoint] }
      end

      # Send back what was sent in, headers, post body etc.
      # @param request_hash [Hash] The request body.
      # @return [Hash]
      def echo(request_hash)
        Arango::Requests::Administration::Echo.execute(server: self, body: request_hash)
      end

      # Return server database engine information
      # @return [Arango::Result]
      def engine
        @engine ||= Arango::Requests::Administration::Engine.execute(server: self)
      end

      # Return true if the server uses the mmfiles engine.
      # @return [Boolean]
      def mmfiles?
        'mmfiles' == engine.name
      end

      # Return true if the server uses the rocksdb engine.
      # @return [Boolean]
      def rocksdb?
        'rocksdb' == engine.name
      end

      # Read global logs from the server.
      # Log levels for the upto and level params:
      # - fatal or 0
      # - error or 1
      # - warning or 2
      # - info or 3
      # - debug or 4
      # The parameters upto and level are mutually exclusive.
      # All params are optional.
      # @param upto [Symbol, String, Integer] Returns all log entries up to log level upto. The default value is info.
      # @param level [Symbol, String, Integer] Returns all log entries of log level level.
      # @param start Returns all log entries such that their log entry identifier (lid value) is greater or equal to start.
      # @param size [Integer] Restricts the result to at most size log entries.
      # @param offset [Integer] Starts to return log entries skipping the first offset log entries. offset and size can be used for pagination.
      # @param search [String] Only return the log entries containing the text specified in search.
      # @param sort [Symbol, String] Sort the log entries either ascending (if sort is :asc) or descending (if sort is :desc) according to their lid values.
      # @return [Arango::Result]
      def log(upto: nil, level: nil, start: nil, size: nil, offset: nil, search: nil, sort: nil)
        sort = sort.to_s if sort
        satisfy_category?(sort, [nil, "asc", "desc"])
        query = Hash.new
        query[:start] = start if start
        query[:size] = size if size
        query[:offset] = offset if offset
        query[:search] = search if search
        query[:sort] = sort if sort
        if upto
          upto = upto.to_s
          satisfy_category?(upto, [nil, "fatal", 0, "error", 1, "warning", 2, "info", 3, "debug", 4])
          query[:upto] = upto
        elsif level
          level = level.to_s
          satisfy_category?(level, [nil, "fatal", 0, "error", 1, "warning", 2, "info", 3, "debug", 4])
          query[:level] = level
        end
        Arango::Requests::Administration::Log.execute(server: self, params: query)
      end

      # Returns the current log level settings
      # @return [Arango::Result]
      def log_level
        Arango::Requests::Administration::GetLogLevel.execute(server: self)
      end

      # Modifies the current log level settings
      # @param log_level_object [Arango::Result, Hash] Must contain all keys as obtained by log_level. Best is to get the object by calling log_level,
      #                                                modifying it, and passing it here.
      # @return Arango::Result
      def log_level=(log_level_object)
        body = if log_level_object.class == Arango::Result
                 log_level_object.to_h
               else
                 log_level_object
               end
        Arango::Requests::Administration::SetLogLevel.execute(server: self, body: body)
      end

      # Return mode information about a server.
      # @return [Symbol] one of :default or :readonly
      def mode
        Arango::Requests::Administration::GetMode.execute(server: self).mode.to_sym
      end

      # Set server mode.
      # @param mode [String, Symbol] one of :default or :readonly
      # @return [Symbol] one of :default or :readonly
      def mode=(mode)
        satisfy_category?(mode, ["default", "readonly", :default, :readonly])
        body = { mode: mode.to_s }
        Arango::Requests::Administration::SetMode.execute(server: self, body: body).mode.to_sym
      end

      # Check if server is read only.
      # @return [Boolean]
      def read_only?
        :readonly == mode
      end

      # Reloads the routing information from the collection routing.
      # @return true
      def reload_routing
        Arango::Requests::Administration::ReloadRouting.execute(server: self)
        true
      end

      # Returns the role of a server in a cluster.
      # SINGLE: the server is a standalone server without clustering
      # COORDINATOR: the server is a Coordinator in a cluster
      # PRIMARY: the server is a DBServer in a cluster
      # SECONDARY: this role is not used anymore
      # AGENT: the server is an Agency node in a cluster
      # UNDEFINED: in a cluster, UNDEFINED is returned if the server role cannot be
      # determined.
      # @return [String]
      def role
        @role ||= Arango::Requests::Administration::Role.execute(server: self).role
      end

      # Check if server role is AGENT.
      # @return [Boolean]
      def agent?
        role == 'AGENT'
      end

      # Check if server role is COORDINATOR.
      # @return [Boolean]
      def coordinator?
        role == 'COORDINATOR'
      end

      # Check if server role is PRIMARY.
      # @return [Boolean]
      def primary?
        role == 'PRIMARY'
      end

      # Check if server role is SECONDARY.
      # @return [Boolean]
      def secondary?
        role == 'SECONDARY'
      end

      # Check if server role is SINGLE.
      # @return [Boolean]
      def single?
        role == 'SINGLE'
      end

      # Check if server is part of a cluster.
      # @return [Boolean]
      def in_cluster?
        coordinator? || primary? || agent? || secondary?
      end

      # Returns the id of a server in a cluster.
      # @return [Boolean]
      def server_id
        request(get: "_admin/server/id").serverId if in_cluster?
      end

      # Returns the statistics information.
      # @return [Arango::Result]
      def statistics
        Arango::Requests::Administration::Statistics.execute(server: self)
      end

      # Returns a description of the statistics returned by /_admin/statistics.
      # @return [Arango::Result]
      def statistics_description
        Arango::Requests::Administration::StatisticsDescription.execute(server: self)
      end

      # Returns status information about the server.
      # @return [Arango::Result]
      def status
        Arango::Requests::Administration::Status.execute(server: self)
      end

      # Check if the server has the enterprise license.
      # @return [Boolean]
      def enterprise?
        @enterprise ||= (status.license == 'enterprise')
      end

      # The servers current system time as a Unix timestamp with microsecond precision of the server
      # @return [Float]
      def time
        Arango::Requests::Administration::Time.execute(server: self).time
      end

      # Return server version details.
      # The response will contain a details attribute with additional information about included components
      # and their versions. The attribute names and internals of the details object may vary depending on platform and ArangoDB version.
      # @return [Arango::Result]
      def detailed_version
        Arango::Requests::Administration::Version.execute(server: self, params: {details: true})
      end

      # The server version string. The string has the format “major.minor.sub”. major and minor will be numeric, and sub may contain a number or
      # a textual version.
      # @return [String]
      def version
        Arango::Requests::Administration::Version.execute(server: self).version
      end

      # Returns the database version that this server requires.
      # @return [String]
      def target_version
        Arango::Requests::Administration::TargetVersion.execute(server: self).version
      end

      # Flushes the write-ahead log. By flushing the currently active write-ahead
      # logfile, the data in it can be transferred to collection journals and
      # datafiles. This is useful to ensure that all data for a collection is
      # present in the collection journals and datafiles, for example, when dumping
      # the data of a collection.
      # @param wait_for_sync [Boolean] Whether or not the operation should block until the not-yet synchronized data in the write-ahead log was
      #                                synchronized to disk.
      # @param wait_for_collector [Boolean] Whether or not the operation should block until the data in the flushed log has been collected by the
      #                                     write-ahead log garbage collector. Note that setting this option to true might block for a long time if
      #                                     there are long-running transactions and the write-ahead log garbage collector cannot
      #                                     finish garbage collection.
      def flush_wal(wait_for_sync: false, wait_for_collector: false)
        params = {
          waitForSync: wait_for_sync,
          waitForCollector: wait_for_collector
        }
        200 == Arango::Requests::Wal::Flush.execute(server: self, params: params).response_code
      end

      # Retrieves the configuration of the write-ahead log. Properties:
      # - allow_oversize_entries: whether or not operations that are bigger than a single logfile can be executed and stored
      # - log_file_size: the size of each write-ahead logfile
      # - historic_logfiles: the maximum number of historic logfiles to keep
      # - reserve_logfiles: the maximum number of reserve logfiles that ArangoDB allocates in the background
      # - throttle_wait: the maximum wait time that operations will wait before they get aborted if case of write-throttling (in milliseconds)
      # - throttle_when_pending: the number of unprocessed garbage-collection operations that, when reached, will activate write-throttling.
      #                          A value of 0 means that write-throttling will not be triggered.
      # return [Arango::Result]
      def wal_properties
        result = request(get: "_admin/wal/properties")
        raise "WAL properties not available." if result.response_code >= 500
        result
      end

      # Configures the behavior of the write-ahead log.
      # @param properties_object [Arango::Result] Obtain the object with wal_properties, modify and pass here.
      #
      def wal_properties=(properties_object)
        body = {
          allowOversizeEntries: properties_object.allow_oversize_entries,
          logfileSize: properties_object.logfile_size,
          historicLogfiles: properties_object.historic_logfiles,
          reserveLogfiles: properties_object.reserve_logfiles,
          throttleWait: properties_object.throttle_wait,
          throttleWhenPending: properties_object.throttle_when_pending
        }
        result = request(put: "_admin/wal/properties", body: body)
        raise "WAL properties not available." if result.response_code >= 500
        result
      end

      # Shutdown the server.
      # @return [Boolean] True if request was successful.
      def shutdown
        200 == request(delete: "_admin/shutdown").response_code
      end
    end
  end
end
