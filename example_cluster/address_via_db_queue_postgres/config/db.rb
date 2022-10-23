# frozen_string_literal: true

Isometric::Config.instance.set_config('database') do
  adapter ENV['ADDRESS_DB_ADAPTER']
  host ENV['ADDRESS_DB_HOST']
  username ENV['ADDRESS_DB_USERNAME']
  password ENV['ADDRESS_DB_PASSWORD']
  database ENV['ADDRESS_DB_DATABASE']
end
