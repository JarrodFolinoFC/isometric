# frozen_string_literal: true

Isometric::Config.instance.set_config('default/db/publish_attributes/create') do
  outbox_model Isometric::OutboxMessage
  queue_name 'db/address/create'
  model Address
  app_id 'address_service'
  nested('headers') do
  end
  nested('settings') do
    correlation_id { SecureRandom.hex }
  end
end

Isometric::Config.instance.set_config('default/db/publish_attributes/update') do
  outbox_model Isometric::OutboxMessage
  queue_name 'db/address/update'
  model Address
  app_id 'address_service'
  nested('headers') do
  end
  nested('settings') do
    correlation_id { SecureRandom.hex }
  end
end

Isometric::Config.instance.set_config('default/db/publish_attributes/delete') do
  outbox_model Isometric::OutboxMessage
  queue_name 'db/address/delete'
  model Address
  app_id 'address_service'
  nested('headers') do
  end
  nested('settings') do
    correlation_id { SecureRandom.hex }
  end
end
