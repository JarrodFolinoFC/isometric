# frozen_string_literal: true

module Isometric
  class PublisherFactory
    DEFAULT_EXCHANGE_NAME = 'direct_name'

    def self.instance(queue_name:, isometric_lookup:, routing_key: nil)
      conn = BunnyConnectionFactory.conn(isometric_lookup: Isometric::DEFAULT_BUNNY_CONNECTION_KEY)
      conn.start
      channel = conn.create_channel
      config = Isometric::Config.instance[isometric_lookup]

      exchange_name = config[:direct_name] || DEFAULT_EXCHANGE_NAME
      exchange = channel.direct(exchange_name)
      channel.queue(queue_name, auto_delete: true).
        bind(exchange, routing_key: routing_key || config[:routing_key])

      @instances = {} if @instances.nil?
      @instances[queue_name] ||= ::Isometric::RabbitPublisher.new(queue_name, channel, exchange, config)
    end
  end
end
