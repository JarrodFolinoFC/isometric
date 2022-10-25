#_frozen_string_literal:_true

Citation.create(:messaging, [])

Citation.create(:polling_publisher, [])
Citation.create(:transactional_outbox, [])
Citation.create(:transactional_inbox, [])
Citation.create(:transaction_log_tailing, [])
Citation.create(:rest_api, [])

Citation.create(:circuit_breaker, [])
Citation.create(:client_side_discovery, [])
Citation.create(:self_registration, [])
Citation.create(:swagger, [])
Citation.create(:reply_channel, [])
Citation.create(:point_to_point_channel, [])
Citation.create(:message_broker, [])
Citation.create(:AMQP, [])
Citation.create(:STOMP, [])
Citation.create(:idempotent_message_handler, [])
Citation.create(:remote_procedure_invocation, [])
Citation.create(:saga, [])
Citation.create(:sagaChoreography, [])
Citation.create(:sagaOrchestration, [])
Citation.create(:saga_state_machine, [])
Citation.create(:aggregate, [])
Citation.create(:domain_event, [])
Citation.create(:event_sourcing, [])
Citation.create(:transaction_script, [])
Citation.create(:cqrs, [])
Citation.create(:api_gateway, [])
Citation.create(:backends_for_frontends, [])
Citation.create(:consumer_driven_contract_test, [])
Citation.create(:consumer_side_contract_test, [])
Citation.create(:service_component_test, [])
Citation.create(:microservice_chassis, [])
Citation.create(:externalized_configuration, [])
Citation.create(:application_metrics, [])
Citation.create(:service_component_test, [])
Citation.create(:service_mesh, [])
Citation.create(:anti_corruption_layer, [])
Citation.create(:avro, [])
Citation.create(:protobuff, [])
# Document Command Event
# ASYNCHRONOUS REQUEST/RESPONSE
# message broker
# REPLICATE DATA
#
# Compensatable transactions—Transactions.
# Pivot transaction—The go/no-go point in a saga.
# Retriable transactions—Transactions that follow the pivot transaction and are guaranteed to succeed.
