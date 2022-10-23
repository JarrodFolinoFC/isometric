# frozen_string_literal: true

require 'grape'
require_relative '../models/address'
require_relative '../../../lib/isometric'

module AddressApiSharedConfig
  %w[db db_publish_attributes redis logger].each do |file|
    require_relative "../config/#{file}"
  end

  SCHEMA = Isometric::SchemaSummary.from_convention("#{__dir__}/../schema/address.json")
  UUID_FIELD = 'uuid'
  SCHEMA_CLASS = ::Address
  FRIENDLY_NAME = SCHEMA_CLASS.to_s.downcase
  VENDOR = 'acme'
  VERSION = 'v1'
end

def grape_format(fields)
  fields.map do |n|
    { name: n, type: String, desc: '' }
  end
end

SC = AddressApiSharedConfig
Isometric::DbConnection.from_convention