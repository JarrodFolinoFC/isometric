# frozen_string_literal: true

Isometric::Config.instance.set_config('rabbit/reply_to/publish_attributes') do
  # Publisher config
  direct_name 'reply_direct'

  # standard bunny/rabbitmq properties
  app_id { Isometric::Config.instance['app']['app-name'] }
end
