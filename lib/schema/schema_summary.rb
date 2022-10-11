module Isometric
  class SchemaSummary
    def initialize
      @schemas = {}
    end

    def add(schema)
      @schemas[schema["$id"]] = schema
      Module.define_method(schema["title"].downcase + "_schema") do
        @schemas[schema["$id"]]
      end
    end

    def self.from_convention(schema_dir)
      return if @schemas
      @schema_summary ||= Isometric::SchemaSummary.new
      schemas = Dir[schema_dir]
      schemas.each do |schema|
        json_parse = JSON.parse(File.open(schema).read)
        @schema_summary.add(json_parse)
        define_method(json_parse["title"].downcase + "_schema") do
          @schemas[json_parse["$id"]]
        end
      end
      @schema_summary
    end

    def schemas
      @schemas
    end
  end
end