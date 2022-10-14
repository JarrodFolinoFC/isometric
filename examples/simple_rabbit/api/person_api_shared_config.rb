# frozen_string_literal: true

require 'grape'
require_relative '../models/person'
require_relative '../../../lib/isometric'

module PersonApiSharedConfig
  %w[db bunny default_publish_attributes redis logger queues].each do |file|
    require_relative "../config/#{file}"
  end

  QUEUE_CONFIG_REFERENCE = Isometric::Config.instance['person_queues']
  SCHEMA = Isometric::SchemaSummary.from_convention("#{__dir__}/../schema/person.json")
  UUID_FIELD = 'uuid'
  SCHEMA_CLASS = ::Person
  FRIENDLY_NAME = SCHEMA_CLASS.to_s.downcase
  VENDOR = 'acme'
  VERSION = 'v1'
end

def grape_format(fields)
  fields.map do |n|
    { name: n, type: String, desc: '' }
  end
end

SC = PersonApiSharedConfig
