# frozen_string_literal: true

Isometric::Config.instance.set_config('redis') do
  host ENV['REDIS_HOST']
  port ENV['REDIS_PORT']&.to_i
end
