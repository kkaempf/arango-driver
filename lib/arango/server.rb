module Arango
  #
  # Arango Server
  #
  class Server
    include Arango::Helper::Satisfaction
    include Arango::Server::Administration
    include Arango::Server::Databases
    include Arango::Server::Monitoring
    include Arango::Server::Tasks
    include Arango::Server::OpalSupport

    attr_reader :async, :host, :port, :tls, :base_uri, :username, :driver_instance
    attr_accessor :current_database

    # Connect to a ArangoDB server.
    # @param username [String]
    # @param password [String]
    # @param host [String]
    # @param port [String]
    # @param tls [Boolean] Use TLS for the connection, optional, default: false.
    # @return [Arango::Server]
    def initialize(username: "root", password:, host: "localhost", port: "8529", tls: false, driver_options: nil)
      @host = host
      @port = port
      @tls = tls
      @username = username
      @base_uri = "http"
      @base_uri += "s" if tls
      @base_uri += "://#{host}:#{port}"
      options = { username: username, password: password }
      driver_options = {} unless driver_options
      @driver_instance = Arango.driver.new(base_uri: base_uri, options: driver_options.merge(options))
    end

    def endpoint
      "tcp://#{@host}:#{@port}"
    end

    # Returns information about the currently running transactions.
    # @return [Arango::Result]
    def transactions
      Arango::Requests::Wal::Transactions.execute(server: self)
    end

    # Check if transactions are running on server.
    # @return [Boolean]
    def transactions_running?
      transactions.running_transactions > 0
    end

    private

    def download(*args)
      @request.download(*args)
    end
  end
end
