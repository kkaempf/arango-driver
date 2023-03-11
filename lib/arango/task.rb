module Arango
  #
  # Arango Task
  #
  class Task
    include Arango::Helper::Satisfaction
    include Arango::Helper::DatabaseAssignment
    include Arango::Helper::ServerAssignment

    class << self
      # Takes a hash and instantiates a Arango::Task object from it.
      #
      # @param task_hash [Hash]
      # @return [Arango::Task]
      def from_h(task_hash, server: nil)
        raise Arango::Error.new(err: :no_task_id) unless task_hash.key?(:id)
        task_hash = task_hash.transform_keys { |k| k.to_s.underscore.to_sym }
        task_hash.merge!(server: server) if server
        if task_hash[:database].class == String
          task_hash[:database] = Arango::Database.new(name: task_hash[:database], server: server)
        end
        created = task_hash.delete(:created)
        offset = task_hash.delete(:offset)
        type = task_hash.delete(:type)
        task = Arango::Task.new(**task_hash)
        task.instance_variable_set(:@created, created)
        task.instance_variable_set(:@offset, offset)
        task.instance_variable_set(:@type, type)
        task
      end

      # Takes a Arango::Result and instantiates a Arango::Task object from it.
      #
      # @param arango_result [Arango::Result]
      # @return [Arango::Task]
      def from_result(arango_result, server: nil)
        from_h(arango_result.to_h, server: server)
      end

      # Delete a task from the server or from a database.
      #
      # @param id [String] The id of the Task
      # @param database [Arango::Database] A database, optional if server is given.
      # @param server [Arango::Server] Server, optional if database is given.
      # @return [Arango::Task]
      def delete(id:, database: nil, server: Arango.current_server)
        args = {id: id}
        if database
          args[:db] = database.name
          Arango::Requests::Task::Delete.execute(server: database.server, args: args)
        elsif server
          Arango::Requests::Task::Delete.execute(server: server, args: args)
        end
        self
      end

      # Gets a task from the server or from a database.
      #
      # @param id [String] The id of the Task
      # @param database [Arango::Database] A database, optional if server is given.
      # @param server [Arango::Server] Server, optional if database is given.
      # @return [Arango::Task]
      def get(id:, database: nil, server: Arango.current_server)
        args = { id: id }
        if database
          args[:db] = database.name
          server = database.server
        end
        result = Arango::Requests::Task::Get.execute(server: server, args: args)
        Arango::Task.from_result(result, server: server)
      end

      # Get all tasks from a server or from a database
      #
      # @param database [Arango::Database] A database, optional if server is given.
      # @param server [Arango::Server] Server, optional if database is given.
      # @return [Array<Arango::Task>]
      def all(database: nil, server: Arango.current_server)
        args = Hash.new
        if database
          args[:db] = database.name
          server = database.server
        end
        result = Arango::Requests::Task::All.execute(server: server, args: args)

        result.map { |task| Arango::Task.from_h(task, server: server) }
      end

      # List all tasks ids from a server or from a database
      #
      # @param database [Arango::Database] A database, optional if server is given.
      # @param server [Arango::Server] Server, optional if database is given.
      # @return [Array<String>]
      def list(database: nil, server: Arango.current_server)
        args = Hash.new
        if database
          args[:db] = database.name
          server = database.server
        end
        result = Arango::Requests::Task::All.execute(server: server, args: args)
        result.map { |task| task[:id] }
      end

      def exists?(id:, database: nil, server: Arango.current_server)
        result = list(database: database, server: server)
        result.include?(id)
      end
    end

    # Access the javascript code of the task.
    # @return [String] The javascript code as string.
    attr_accessor :command
    alias javascript_command command
    alias javascript_command= command=

    # The Task id.
    # @return [String]
    attr_accessor :id

    # The Task name.
    # @return [String] or nil
    attr_accessor :name

    # The number of seconds initial delay.
    # @return [Integer] or nil
    attr_accessor :offset

    # Hash of params to pass to the command
    # # @return [Hash] or nil
    attr_accessor :params

    # Number of seconds between executions.
    # @return [Integer] or nil
    attr_accessor :period

    # Time this task has been created at, timestamp.
    # return [BigDecimal]
    attr_reader :created

    # Database the task belongs to
    # return [Arango::Database] or nil
    attr_reader :database

    # Server the Task belongs to.
    # return [Arango::Server]
    attr_reader :server

    # Task type.
    # return [Symbol] Either :periodic or :timed.
    attr_reader :type

    # Instantiate a new task.
    #
    # @param command [String] The javascript code to execute, optional.
    # @param name [String] The task name, optional.
    # @param offset [Integer] The number of seconds initial delay, optional.
    # @param params [Hash] Hash of params to pass to the command, optional.
    # @param period [Integer] Number of seconds between executions, optional.
    # @return [Arango::Task]
    def initialize(id: nil, command: nil, name: nil, offset: nil, params: nil, period: nil, database: nil, server: Arango.current_server)
      @args = Hash.new
      if database
        assign_database(database)
        @requester = @database
        @args[:db] = @database.name
      elsif server
        assign_server(server)
        @requester = @server
      end
      set_id id
      @command = command
      @name = name
      @offset = offset
      @params = params
      @period = period
    end

    # set id
    def set_id id
      @id = id
      if @id
        @args[:id] = @id
      else
        @args.delete :id
      end
    end

    # Convert the Task to a Hash
    # @return [Hash]
    def to_h
      {
        id: @id,
        name: @name,
        type: @type,
        period: @period,
        command: @command,
        params: @params,
        created: @created,
        cache_name: @cache_name,
        database: @database ? @database.name : nil
      }.delete_if{|_,v| v.nil?}
    end

    # Create the task in the database.
    # return [Arango::Task] Returns the task.
    def create
      body = {
        name: @name,
        command: @command,
        period: @period,
        offset: @offset,
        params: @params
      }
      if @id
        result = Arango::Requests::Task::CreateWithId.execute(server: @requester, args: @args, body: body)
      else
        result = Arango::Requests::Task::Create.execute(server: @requester, args: @args, body: body)
        set_id result.id
      end
      @type = result.type.to_sym
      @created = result.created
      @name = result.name
      self
    end

    # Delete the task from the database.
    # return nil.
    def delete
      Arango::Requests::Task::Delete.execute(server: @requester, args: @args)
      nil
    end
  end
end
