module Arango
  module Requests
    module Administration
      class SetLogLevel < Arango::Request
        self.request_method = :put

        self.uri_template = "/_admin/log/level"

        body :agency
        body :agencycomm
        body :agencystore
        body :aql
        body :arangosearch
        body :authentication
        body :authorization
        body :backup
        body :bench
        body :cache
        body :cluster
        body :clustercomm
        body :collector
        body :communication
        body :compactor
        body :config
        body :crash
        body :datafiles
        body :development
        body :dump
        body :engines
        body :flush
        body :general
        body :graphs
        body :heartbeat
        body :httpclient
        body :ldap
        body :license
        body :libiresearch
        body :maintenance
        body :memory
        body :mmap
        body :performance
        body :pregel
        body :queries
        body :rep_state
        body :replication
        body :replication2
        body :requests
        body :restore
        body :rocksdb
        body :security
        body :ssl
        body :startup
        body :statistics
        body :supervision
        body :syscall
        body :threads
        body :trx
        body :ttl
        body :v8
        body :validation
        body :views
        code 200, :success
        code 400, "Request body invalid!"
        code 405, "Invalid request method!"
        code 500, "Server out of memory!"
      end
    end
  end
end
