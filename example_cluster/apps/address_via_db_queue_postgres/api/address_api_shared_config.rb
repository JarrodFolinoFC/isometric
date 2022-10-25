# frozen_string_literal: true

require 'grape'
require_relative '../models/address'
require_relative '../../../../lib/isometric'

GLOBAL_SC = Isometric::ApiConfigManager.new(
  config_files: %w[db db_publish_attributes redis logger].map { |file|
    "#{__dir__}/../config/#{file}"
  },
  schema_file: "#{__dir__}/../schema/address.json", uuid: 'uuid',
  schema_class: ::Address, vendor: 'acme', version: 'v1'
)

GLOBAL_SC.load_configs
GLOBAL_SC.load_schema

Isometric::DbConnection.from_convention