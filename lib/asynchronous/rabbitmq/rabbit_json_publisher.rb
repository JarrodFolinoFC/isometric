# frozen_string_literal: true

require 'json'

module Isometric
  class RabbitJsonPublisher
    DEFAULT_EXCHANGE_NAME = 'direct_name'

    attr_reader :channel, :exchange, :exchange_name, :queue_name, :settings

    def initialize(queue_name, channel, exchange, settings = {})
      @queue_name = queue_name
      @exchange_name = settings[:direct_name] || DEFAULT_EXCHANGE_NAME
      @settings = settings
      @channel = channel
      @exchange = exchange
    end

    def publish
      evaluated_hash = Isometric::Config.evaluate_hash(@settings)
      payload = yield
      payload = payload.to_json unless payload.instance_of?(String)
      exchange.publish(payload, evaluated_hash)
      nil
    end

    def publish_with_settings(settings)
      payload = yield
      exchange.publish(payload, settings)
    end

    def publish_model(model)
      evaluated_hash = Isometric::Config.evaluate_hash(@settings)
      exchange.publish(model.attributes.to_json,
                       evaluated_hash)
    end
  end
end
