# frozen_string_literal: true

Isometric::Config.instance.set_config('database') do
  adapter ENV['DB_ADAPTER']
  host ENV['DB_HOST']
  username ENV['DB_USERNAME']
  password ENV['DB_PASSWORD']
  database ENV['DB_DATABASE']
end
