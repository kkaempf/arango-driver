module Arango
  # Arango DocumentCollection
  module DocumentCollection
    # Arango DocumentCollection Indexes
    module Indexes
      # === INDEXES ===
      def create_index(type: "hash", fields:, unique: nil, sparse: nil,
                       geoJson: nil, minLength: nil, deduplicate: nil)
        Arango::Index.new(collection: self, type: type, fields: fields,
                          unique: unique, sparse: sparse, geo_json: geoJson,
                          min_length: minLength, deduplicate: deduplicate).create
      end

      def get_index(id:)
        Arango::Index.get(collection: self, id: id)
      end

      def indexes
        Arango::Index.list(collection: self)
      end

      def delete_index index:
        index.delete
      end
    end
  end
end
