# frozen_string_literal: true

Isometric::Config.instance.set_config('db/pollers/create') do
  outbox_model Isometric::OutboxMessage
  query "
    select * from outbox where processed_at is nil and queue = 'db/address/create'
  "
end
