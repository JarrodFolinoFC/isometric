# frozen_string_literal: true

require 'grape'
require_relative '../../../../lib/isometric'

configs = %w[db redis logger].map { |file| "#{__dir__}/../config/#{file}" }

GLOBAL_SC = Isometric::ApiConfigManager.new(
  config_files: configs,
  schema_file: "#{__dir__}/../schema/outbox_message.json", uuid: 'uuid',
  schema_class: ::Isometric::OutboxMessage, vendor: 'acme', version: 'v1'
)

GLOBAL_SC.load
GLOBAL_SC.connect_db
