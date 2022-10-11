# frozen_string_literal: true

require 'bunny'

module Isometric
  class BunnyConnectionFactory
    class << self
      attr_reader :connections
    end

    def self.conn(isometric_lookup:, password: nil, server: nil, vhost: nil, user: nil)
      @connections ||= []
      config = Isometric::Config.instance[isometric_lookup]
      cs = "amqps://#{user || config[:user]}:" \
    "#{password || config[:password]}" \
    "@#{server || config[:server]}" \
    "/#{vhost || config[:vhost]}"
      bunny = Bunny.new(cs)
      @connections << bunny
      bunny
    end

    def self.from_convention
      conn(isometric_lookup: Isometric::DEFAULT_BUNNY_CONNECTION_KEY)
    end
  end
end
