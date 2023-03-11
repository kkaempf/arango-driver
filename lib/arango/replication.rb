module Arango
  #
  # Arango Replication
  #
  class Replication
    include Arango::Helper::Satisfaction

    def initialize(master:, slave:, adaptive_polling: nil, auto_resync: nil, auto_resync_retries: nil, chunk_size: nil, connect_timeout: nil,
                   connection_retry_wait_time: nil, idle_max_wait_time: nil, idle_min_wait_time: nil, include_system: true, incremental: nil,
                   initial_sync_max_wait_time: nil, max_connect_retries: nil, request_timeout: nil, require_from_present: nil,
                   restrict_collections: nil, restrict_type: nil, verbose: nil)
      @adaptive_polling = adaptive_polling
      @auto_resync = auto_resync
      @auto_resync_retries = auto_resync_retries
      @chunk_size = chunk_size
      @connect_timeout = connect_timeout
      @connection_retry_wait_time = connection_retry_wait_time
      @idle_max_wait_time = idle_max_wait_time
      @idle_min_wait_time = idle_min_wait_time
      @include_system = include_system
      @incremental = incremental
      @initial_sync_max_wait_time = initial_sync_max_wait_time,
      @max_connect_retries = max_connect_retries
      @request_timeout = request_timeout
      @require_from_present = require_from_present
      @verbose = verbose
      assign_master(master)
      assign_restrict_collections(restrict_collections)
      assign_restrict_type(restrict_type)
      assign_slave(slave)
    end

    attr_accessor :adaptive_polling, :auto_resync, :auto_resync_retries, :chunk_size, :connect_timeout, :connection_retry_wait_time, :endpoint,
                  :idle_max_wait_time, :idle_min_wait_time, :include_system, :incremental, :initial_sync_max_wait_time, :max_connect_retries,
                  :password, :request_timeout, :require_from_present, :username, :verbose
    attr_reader :master, :restrict_collections, :restrict_type, :slave

    def master=(master)
      satisfy_class?(master, Arango::Database)
      @master = master
      @master_server = @master.server
    end
    alias assign_master master=

    def slave=(slave)
      satisfy_class?(slave, Arango::Database)
      @slave = slave
      @slave_server = @slave.server
    end
    alias assign_slave slave=

    def restrict_type=(restrict_type)
      satisfy_category?(restrict_type, ["include", "exclude", nil])
      @restrict_type = restrict_type
    end
    alias assign_restrict_type restrict_type=

    def restrict_collections=(restrict_collections)
      if restrict_collections.nil?
        @restrict_collections = nil
      else
        @restrict_collections = restrict_collections.map do |v|
          case v
          when String then v
          when Arango::DocumentCollection::Mixin then v.name
          else raise "wrong type"
          end
        end
      end
    end
    alias assign_restrict_collections restrict_collections=


    def to_h
      master
      {
        master: {
          database: @master.name,
          username: @master_server.username,
          endpoint: @master_server.endpoint
        },
        slave: {
          database: @slave.name,
          username: @slave_server.username,
          endpoint: @slave_server.endpoint
        },
        options: {
          adaptivePolling: @adaptive_polling,
          autoResync: @auto_resync,
          autoResyncRetries: @auto_resync_retries,
          chunkSize: @chunk_size,
          connectionRetryWaitTime: @connection_retry_wait_time,
          connectTimeout: @connect_timeout,
          idleMaxWaitTime: @idle_max_wait_time,
          idleMinWaitTime: @idle_min_wait_time,
          includeSystem: @include_system,
          incremental: @incremental,
          initialSyncMaxWaitTime: @initial_sync_max_wait_time,
          maxConnectRetries: @max_connect_retries,
          requestTimeout: @request_timeout,
          requireFromPresent: @require_from_present,
          restrictCollections: @restrict_collections,
          restrictType: @restrict_type,
          verbose: @verbose
        }.delete_if{|k,v| v.nil?}
      }
    end

# SYNCRONISATION

    def sync
      body = {
        username: @master_server.username,
        password: @master_server.password,
        database: @master.name,
        endpoint: @master_server.endpoint,
        includeSystem: @include_system,
        incremental:   @incremental,
        initialSyncMaxWaitTime: @initial_sync_max_wait_time,
        restrictCollections:    @restrict_collections,
        restrictType:  @restrict_type
      }
      @slave.request("PUT", "_api/replication/sync", body: body)
    end

# ENSLAVING

    def enslave
      body = {
        username: @master_server.username,
        password: @master_server.password,
        database: @database.name,
        endpoint: @server.endpoint,
        adaptivePolling:   @adaptive_polling,
        autoResync:        @auto_resync,
        autoResyncRetries: @auto_resync_retries,
        chunkSize:         @chunk_size,
        connectionRetryWaitTime: @connection_retry_wait_time,
        connectTimeout:    @connect_timeout,
        idleMaxWaitTime:   @idle_max_wait_time,
        idleMinWaitTime:   @idle_min_wait_time,
        includeSystem:     @include_system,
        initialSyncMaxWaitTime: @initial_sync_max_wait_time,
        maxConnectRetries: @max_connect_retries,
        requestTimeout:    @request_timeout,
        requireFromPresent: @require_from_present,
        restrictCollections: @restrict_collections,
        restrictType:      @restrict_type,
        verbose:           @verbose
      }
      @slave.request("PUT", "_api/replication/make-slave", body: body)
    end

# REPLICATION

    def start(from: nil)
      @slave.request("PUT", "_api/replication/applier-start", query: {from: from})
    end

    def stop
      @slave.request("PUT", "_api/replication/applier-stop")
    end

    def state
      @slave.request("GET", "_api/replication/applier-state")
    end

    def configuration
      @slave.request("GET", "_api/replication/applier-config")
    end

    def modify
      body = {
        username: @master_server.username,
        password: @master_server.password,
        database: @master.name,
        endpoint: @master_server.endpoint,
        adaptivePolling:  @adaptive_polling,
        autoResync: @auto_resync,
        autoResyncRetries: @auto_resync_retries,
        autoStart:  @auto_start, # TODO
        chunkSize:  @chunk_size,
        connectionRetryWaitTime: @connection_retry_wait_time,
        connectTimeout:  @connect_timeout,
        idleMaxWaitTime: @idle_max_wait_time,
        idleMinWaitTime: @idle_min_wait_time,
        includeSystem:   @include_system,
        initialSyncMaxWaitTime: @initial_sync_max_wait_time,
        maxConnectRetries: @max_connect_retries,
        requestTimeout:  @request_timeout,
        requireFromPresent: @require_from_present,
        restrictCollections: @restrict_collections,
        restrictType:    @restrict_type,
        verbose:  @verbose
      }
      @slave.request("PUT", "_api/replication/applier-config", body: body)
    end
    alias modify_replication modify

    # LOGGER

    def logger
      @slave.request("GET", "_api/replication/logger-state")
    end

    def logger_follow(from: nil, to: nil, chunk_size: nil, include_system: nil)
      query = {
        from: from,
        to:   to,
        chunkSize:     chunk_size,
        includeSystem: include_system
      }
      @slave.request("GET", "_api/replication/logger-follow", query: query)
    end

    def logger_first_tick
      @slave.request("GET", "_api/replication/logger-first-tick", key: :firstTick)
    end

    def logger_range_tick
      @slave.request("GET", "_api/replication/logger-tick-ranges")
    end

    # SERVER-ID

    def server_id
      @slave.request("GET", "_api/replication/server-id", key: :serverId)
    end
  end
end
