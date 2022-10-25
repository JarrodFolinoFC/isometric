# frozen_string_literal: true

Isometric::Config.instance.set_config('database') do
  adapter ENV['PERSON_DB_ADAPTER']
  host ENV['PERSON_DB_HOST']
  username ENV['PERSON_DB_USERNAME']
  password ENV['PERSON_DB_PASSWORD']
  database ENV['PERSON_DB_DATABASE']
end
