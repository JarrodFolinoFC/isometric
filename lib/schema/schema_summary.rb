# frozen_string_literal: true

module Isometric
  class SchemaSummary
    def initialize
      @schemas = {}
    end

    def add(schema)
      @schemas[schema['$id']] = schema
    end

    def self.grape_format()

    end

    def self.from_convention(schema_dir)
      return if @schemas

      @schema_summary ||= Isometric::SchemaSummary.new
      schemas = Dir[schema_dir]
      schemas.each do |schema|
        json_parse = JSON.parse(File.open(schema).read)
        @schema_summary.add(json_parse)

        define_method("#{json_parse['title'].downcase}_schema") do
          @schemas[json_parse['$id']]
        end

        define_method("#{json_parse['title'].downcase}_schema_required_fields") do
          json_parse = @schemas[json_parse['$id']]
          json_parse['required']
        end

        define_method("#{json_parse['title'].downcase}_schema_fields") do
          json_parse = @schemas[json_parse['$id']]
          json_parse['properties'].keys
        end

        define_method("#{json_parse['title'].downcase}_schema_optional_fields") do
          json_parse = @schemas[json_parse['$id']]
          json_parse['properties'].keys - json_parse['required']
        end
      end
      @schema_summary
    end

    attr_reader :schemas
  end
end
