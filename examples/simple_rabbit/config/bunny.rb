# frozen_string_literal: true

Isometric::Config.instance.set_config(Isometric::DEFAULT_BUNNY_CONNECTION_KEY) do
  user ENV['BUNNY_CONNECTION_USER']
  password ENV['BUNNY_CONNECTION_PASSWORD']
  server ENV['BUNNY_CONNECTION_SERVER']
  vhost ENV['BUNNY_CONNECTION_VHOST']
end
