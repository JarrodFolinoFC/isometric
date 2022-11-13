# frozen_string_literal: true

module Isometric
  module RabbitHooks
    PUBLISH_CONFIRMATION = proc do |_delivery_info, properties, _body|
      PublisherFactory.instance(queue_name: properties[:correlation_id],
                                isometric_lookup: 'rabbit/reply_to/publish_attributes').publish do
        {
          correlation_id: properties[:correlation_id],
          application_name: 'App Name',
          message: 'Success'
        }.to_json
      end
    end

    CLOSE_CHANNEL = proc do |queue, _delivery_info, _properties, _body|
      channel = queue.channel
      channel.close
      channel.connection.close
    end
  end
end
