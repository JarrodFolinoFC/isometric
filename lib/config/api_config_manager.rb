module Isometric
  class ApiConfigManager
    attr_reader :schema_class, :uuid, :schema, :vendor, :version

    def initialize(config_files: nil, schema_file: nil, uuid: nil,
                   schema_class: nil, vendor: nil, version: nil)
      @config_files = config_files
      @uuid = uuid
      @schema_file = schema_file
      @schema_class = schema_class
      @vendor = vendor
      @version = version
    end

    def load
      load_configs
      load_schema
    end

    def load_configs
      @config_files.each do |file|
        require_relative file
      end
    end

    def load_schema
      @schema = Isometric::SchemaSummary.from_convention(@schema_file)
    end

    def connect_db
      Isometric::DbConnection.from_convention
    end

    def friendly_name
      @schema_class.to_s.split('::').last.tableize.singularize
    end
  end
end
