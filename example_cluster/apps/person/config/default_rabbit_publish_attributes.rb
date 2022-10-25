# frozen_string_literal: true

require 'securerandom'

Isometric::Config.instance.set_config('default/rabbit/publish_attributes') do
  message_id { SecureRandom.hex }
  correlation_id { SecureRandom.hex }
  # user_id 123
  nested(:headers) do
  end
end
