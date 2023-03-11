module Arango
  #
  # Arango Index
  #
  class Index
    include Arango::Helper::Satisfaction
    include Arango::Helper::DatabaseAssignment
    def self.list(collection:)
      params = { collection: collection.name }
      result = Arango::Requests::Index::ListAll.execute(server: collection.database.server, params: params)
      if result.response_code == 200
        return result.indexes.map do |v|
           self.new collection: collection, fields: v[:fields], type: v[:type], deduplicate: v[:deduplicate],
                    geo_json: v[:geo_json], min_length: v[:min_length], sparse: v[:sparse], unique: v[:unique]
        end
      end
      # FIXME - raise error
      nil
    end

    # id is "CollectionName/XXXX"
    def self.get collection:, id:
      c, i = id.split '/' # Requests would convert / to %2F
      Arango::Requests::Index::Get.execute(server: collection.database.server, args: {collection: c, id: i})
    end

    def initialize(collection:, fields:, cache_name: nil, deduplicate: nil, geo_json: nil, min_length: nil, sparse: nil,
                   type: "hash", unique: nil)
      @collection = collection
      assign_database(@collection.database)
      unless cache_name.nil?
        @cache_name = cache_name
        @server.cache.save(:index, cache_name, self)
      end
      body = {}
      body[:type]        ||= type
      body[:sparse]      ||= sparse
      body[:unique]      ||= unique
      body[:fields]      ||= fields.is_a?(String) ? [fields] : fields
      body[:deduplicate] ||= deduplicate
      body[:geo_json]     ||= geo_json
      body[:min_length]   ||= min_length

      assign_attributes(body)
    end

# === DEFINE ===

    attr_accessor :cache_name, :deduplicate, :fields, :geo_json, :min_length, :sparse, :unique
    attr_reader :collection, :database, :server, :type, :name, :id, :key, :is_newly_created

    def type=(type)
      satisfy_category?(type, %w[hash skiplist persistent geo fulltext primary])
      @type = type
    end
    alias assign_type type=

    def assign_attributes(result)
      @id          = result[:id] || @id
      @name        = result[:name] || @name
      @key         = @id&.split("/")&.dig(1)
      @type        = assign_type(result[:type] || @type)
      @unique      = result[:unique]      || @unique
      @fields      = result[:fields]      || @fields
      @sparse      = result[:sparse]      || @sparse
      @geo_json    = result[:geoJson]     || @geo_json
      @min_length  = result[:minLength]   || @min_length
      @deduplicate = result[:deduplicate] || @deduplicate
      @is_newly_created = result[:is_newly_created]
      @estimates   = result[:estimates]   || @estimates
    end

# === DEFINE ===

    def to_h
      {
        key: @key,
        id: @id,
        name: @name,
        body: @body,
        type: @type,
        sparse: @sparse,
        unique: @unique,
        fields: @fields,
        idCache: @idCache,
        geoJson: @geo_json,
        minLength: @min_length,
        deduplicate: @deduplicate,
        collection: @collection.name
      }.delete_if{|k,v| v.nil?}
    end

# === COMMANDS ===

    def create
      body = {
        fields:      @fields,
        type:        @type
      }
      params = { collection: @collection.name }
      case @type.to_sym
      when :hash
        body[:deduplicate] = @deduplicate if @deduplicate
        body[:sparse] = @sparse if @sparse
        body[:unique] = @unique if @unique
      when :fulltext
        body[:min_length] = @min_length if @min_length
      when :general
        body[:deduplicate] = @deduplicate if @deduplicate
        body[:name] = @name if @name
        body[:sparse] = @sparse if @sparse
        body[:unique] = @unique if @unique
      when :geo
        body[:geo_jso] = @geo_json if @geo_json
      when :persistent
        body[:sparse] = @sparse if @sparse
        body[:unique] = @unique if @unique
      when :skiplist
        body[:deduplicate] = @deduplicate if @deduplicate
        body[:sparse] = @sparse if @sparse
        body[:unique] = @unique if @unique
      when :ttl
        body[:expire_after] = @expire_after if @expire_after
      else
        raise "Unknown index type #{@type.to_sym}"
      end
      result = Arango::Requests::Index::Create.execute(server: @database.server, params: params, body: body)
      assign_attributes result
      self
    end

    def to_s
      "Index(#{@id}:#{@type.to_sym}-#{@fields})"
    end

    def delete
      c, i = @id.split '/' # Requests would convert / to %2F
      Arango::Requests::Index::Delete.execute(server: @database.server, args: { collection: c, id: i})
    end
  end
end
