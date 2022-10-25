# frozen_string_literal: true

require 'grape'
require_relative '../models/person'
require_relative '../../../../lib/isometric'

configs = %w[db bunny default_rabbit_publish_attributes redis logger queues].map { |file|
  "#{__dir__}/../config/#{file}"
}

GLOBAL_SC = Isometric::ApiConfigManager.new(
  config_files: configs,
  schema_file: "#{__dir__}/../schema/person.json", uuid: 'uuid',
  schema_class: ::Person, vendor: 'acme', version: 'v1'
)

GLOBAL_SC.load
GLOBAL_SC.connect_db

QUEUES = Isometric::Config.instance['person_queues']
