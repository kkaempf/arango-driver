require_relative 'spec_helper'

describe "Arango::Task" do
  before :all do
    @server = connect
  end

  context "Server" do
    before :each do
      begin
        @server.delete_task(id: '1')
      rescue
      end
      begin
        @server.delete_task(id: '2')
      rescue
      end
      begin
        @server.delete_task(id: '3')
      rescue
      end
    end

    after :each do
      begin
        @server.delete_task(id: '1')
      rescue
      end
      begin
        @server.delete_task(id: '2')
      rescue
      end
      begin
        @server.delete_task(id: '3')
      rescue
      end
    end

    it "new_task" do
      task = @server.new_task(id: '1')
      expect(task).to be_a Arango::Task
    end

    it "get_task" do
      task = @server.new_task(id: '1')
      task.command = '1+1'
      task.period = 2
      task.create
      expect(task).to be_a Arango::Task
      t = @server.get_task(id: '1')
      expect(t).to be_a Arango::Task
      expect(t.id).to eq('1')
    end

    it "all_tasks" do
      %w[1 2 3].each do |id|
        @server.new_task(id: id, command: '1+1', period: 2).create
      end
      all_tasks = @server.all_tasks
      expect(all_tasks.size).to eq 3
      expect(all_tasks.map(&:id).sort).to eq %w[1 2 3]
    end

    it "list_tasks" do
      %w[1 2 3].each do |id|
        @server.new_task(id: id, command: '1+1', period: 2).create
      end
      list = @server.list_tasks
      expect(list.size).to eq 3
      expect(list.sort).to eq %w[1 2 3]
    end

    it "delete_tasks" do
      %w[1 2 3].each do |id|
        @server.new_task(id: id, command: '1+1', period: 2).create
      end
      @server.delete_task(id: '2')
      list = @server.list_tasks
      expect(list.size).to eq 2
      expect(list.sort).to eq %w[1 3]
    end

    it "task_exists?" do
      %w[1 2 3].each do |id|
        @server.new_task(id: id, command: '1+1', period: 2).create
      end
      expect(@server.task_exists?(id: '2')).to be true
      expect(@server.task_exists?(id: '5')).to be false
    end
  end

  context "Database" do
    before :all do
      begin
        @server.delete_database(name: "TaskDatabase")
      rescue
      end
      @database = @server.create_database(name: "TaskDatabase")
    end

    before :each do
      begin
        @database.delete_task(id: '1')
      rescue
      end
      begin
        @database.delete_task(id: '2')
      rescue
      end
      begin
        @database.delete_task(id: '3')
      rescue
      end
    end

    after :each do
      begin
        @database.delete_task(id: '1')
      rescue
      end
      begin
        @database.delete_task(id: '2')
      rescue
      end
      begin
        @database.delete_task(id: '3')
      rescue
      end
    end

    after :all do
      @server.delete_database(name: "TaskDatabase")
    end

    it "new_task" do
      task = @database.new_task(id: '1')
      expect(task).to be_a Arango::Task
    end

    it "get_task" do
      task = @database.new_task(id: '1')
      task.command = '1+1'
      task.period = 2
      task.create
      expect(task).to be_a Arango::Task
      t = @database.get_task(id: '1')
      expect(t).to be_a Arango::Task
      expect(t.id).to eq('1')
    end

    it "all_tasks" do
      %w[1 2 3].each do |id|
        @database.new_task(id: id, command: '1+1', period: 2).create
      end
      all_tasks = @database.all_tasks
      expect(all_tasks.size).to eq 3
      expect(all_tasks.map(&:id).sort).to eq %w[1 2 3]
    end

    it "list_tasks" do
      %w[1 2 3].each do |id|
        @database.new_task(id: id, command: '1+1', period: 2).create
      end
      list = @database.list_tasks
      expect(list.size).to eq 3
      expect(list.sort).to eq %w[1 2 3]
    end

    it "delete_tasks" do
      %w[1 2 3].each do |id|
        @database.new_task(id: id, command: '1+1', period: 2).create
      end
      @database.delete_task(id: '2')
      list = @database.list_tasks
      expect(list.size).to eq 2
      expect(list.sort).to eq %w[1 3]
    end

    it "task_exists?" do
      %w[1 2 3].each do |id|
        @database.new_task(id: id, command: '1+1', period: 2).create
      end
      expect(@database.task_exists?(id: '2')).to be true
      expect(@database.task_exists?(id: '5')).to be false
    end
  end

  context "Arango::Task itself" do
    before :all do
      begin
        @server.delete_database(name: "TaskDatabase")
      rescue
      end
      @database = @server.create_database(name: "TaskDatabase")
    end

    before :each do
      begin
        @server.delete_task(id: "mytaskid")
      rescue
      end
    end

    after :each do
      begin
        @server.delete_task(id: "mytaskid")
      rescue
      end
    end

    after :all do
      @server.delete_database(name: "TaskDatabase")
    end

    it "create new instance without id and check params" do
      myArangoTask = Arango::Task.new name: "MyTaskID",
                                      command: "(function(params) { require('@arangodb').print(params); })(params)",
                                      params: {foo: "bar", bar: "foo"}, period: 2, database: @database
      myArangoTask.create
      expect(myArangoTask.params[:foo]).to eq "bar"
      expect(myArangoTask.id).to be_a String
      myArangoTask.delete
    end

    it "create a new Task instance and check created" do
      myArangoTask = Arango::Task.new id: "mytaskid", name: "MyTaskID",
                                      command: "(function(params) { require('@arangodb').print(params); })(params)",
                                      params: {foo: "bar", bar: "foo"}, period: 2, database: @database
      expect([BigDecimal, Float].include?(myArangoTask.create.created.class)).to eq true
      myArangoTask.delete
    end

    it "create a new Task instance with ID" do
      myArangoTask = Arango::Task.new id: "mytaskid", name: "MyTaskID",
                                      command: "(function(params) { require('@arangodb').print(params); })(params)",
                                      params: {"foo2": "bar2", "bar2": "foo2"}, period: 2, offset: 4, database: @database
      myArangoTask.create
      expect(myArangoTask.params[:foo2]).to eq "bar2"
      myArangoTask.delete
    end

    it "fail to duplicate a Task instance with ID" do
      val = nil
      begin
        myArangoTask = Arango::Task.new id: "mytaskid", name: "MyTaskID",
                                        command: "(function(params) { require('@arangodb').print(params); })(params)",
                                        params: {"foo21": "bar2", "bar21": "foo21"}, period: 2, database: @database
        myArangoTask.create
        myArangoTask2 = Arango::Task.new id: "mytaskid", name: "MyTaskID",
                                        command: "(function(params) { require('@arangodb').print(params); })(params)",
                                        params: {"foo21": "bar2", "bar21": "foo21"}, period: 2, database: @database
        myArangoTask2.create
      rescue Arango::Error => e
        val = e.message
      end
      expect(val).to eq "duplicate task id"
      myArangoTask.delete
    end

    it "can delete tasks" do
      myArangoTask = Arango::Task.new id: "mytaskid", command: '1+1', period: 2, database: @database
      myArangoTask.create
      expect(@database.list_tasks).to include('mytaskid')
      expect(myArangoTask.delete).to be nil
      expect(@database.list_tasks).not_to include('mytaskid')
    end
  end
end
