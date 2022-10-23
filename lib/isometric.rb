# frozen_string_literal: true

%w[
  active_record/active_model_helper

  asynchronous/db_outbox/models/outbox_acks
  asynchronous/db_outbox/models/outbox_message
  asynchronous/db_outbox/factories/outbox_publisher_factory
  asynchronous/db_outbox/factories/outbox_poller_factory
  asynchronous/db_outbox/hooks/db_confirmation.rb
  asynchronous/db_outbox/base_outbox_poller
  asynchronous/db_outbox/outbox_publisher

  asynchronous/base_event_listener
  asynchronous/rabbitmq/event_listener
  asynchronous/rabbitmq/rabbit_json_publisher
  asynchronous/rabbitmq/queue_manager
  asynchronous/rabbitmq/default_rabbit_message_headers
  asynchronous/rabbitmq/factories/bunny_connection_factory
  asynchronous/rabbitmq/factories/event_listener_factory
  asynchronous/rabbitmq/factories/publisher_factory
  asynchronous/rabbitmq/factories/queue_manager_factory
  asynchronous/rabbitmq/hooks

  config/config
  config/configuration_dsl
  config/defaults

  discovery/registry
  discovery/factories/registry_factory

  factories/db_connection
  factories/logger

  response/response
  schema/schema_summary

  citations/citation
].each do |lib|
  require_relative lib
end

Citation.set_root
