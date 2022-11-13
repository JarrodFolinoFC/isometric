# frozen_string_literal: true

Isometric::Config.instance.set_config('database') do
  adapter ENV['OUTBOX_MESSAGE_DB_ADAPTER']
  host ENV['OUTBOX_MESSAGE_DB_HOST']
  username ENV['OUTBOX_MESSAGE_DB_USERNAME']
  password ENV['OUTBOX_MESSAGE_DB_PASSWORD']
  database ENV['OUTBOX_MESSAGE_DB_DATABASE']
end
