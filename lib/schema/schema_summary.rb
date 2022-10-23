# frozen_string_literal: true

module Isometric
  class SchemaSummary
    def initialize(schema)
      @schema = schema
    end

    def type(field)
      @schema.dig('properties', field, 'type')
    end

    def title
      @schema['title']
    end

    def details(field)
      data = @schema.dig('properties', field)
      { name: field, type: ruby_type_mapping(data['type']), description: data['description'] }
    end

    def description(field)
      @schema.dig('properties', field, 'description')
    end

    def required_fields
      @schema['required']
    end

    def optional_fields
      fields - required_fields
    end

    def fields
      @schema['properties'].keys
    end

    def ruby_type_mapping(type)
      {
        'null' => ::NilClass,
        'object' => ::Hash,
        'array' => ::Array,
        'number' => ::Numeric,
        'boolean' => ::Grape::API::Boolean,
        'string' => ::String
      }[type]
    end

    def self.from_convention(schema_file)
      schema = File.open(schema_file).read
      Isometric::SchemaSummary.new(JSON.parse(schema))
    end
  end
end
