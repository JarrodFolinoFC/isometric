# frozen_string_literal: true

require 'grape'
require_relative '../models/address'
require_relative '../../../../lib/isometric'

configs = %w[db redis logger].map { |file|
  "#{__dir__}/../config/#{file}"
} + ["#{__dir__}/../../../shared/config/address/db_publish_attributes"]

GLOBAL_SC = Isometric::ApiConfigManager.new(
  config_files: configs,
  schema_file: "#{__dir__}/../schema/address.json", uuid: 'uuid',
  schema_class: ::Address, vendor: 'acme', version: 'v1'
)

GLOBAL_SC.load
GLOBAL_SC.connect_db