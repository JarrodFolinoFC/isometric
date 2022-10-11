# frozen_string_literal: true

require 'securerandom'

Isometric::Config.instance.set_config('default/rabbit/publish_attributes') do
  # Publisher config
  direct_name 'direct_one'
  exchange_name 'ex1'
  routing_key 'routing_key_one'

  # rabbitmq basic.properties
  # app_id { Isometric::Config.instance['app']['app-name'] }
  # content_type 'application/json'
  # content_encoding ''
  # delivery_mode ''
  # timestamp { Time.now }
  # expiration { Time.now }
  # type 'type'
  # reply_to 'reply_queue'
  # priority 1
  message_id { SecureRandom.hex }
  correlation_id { SecureRandom.hex }
  # user_id 123
  nested(:headers) do
  end
end
