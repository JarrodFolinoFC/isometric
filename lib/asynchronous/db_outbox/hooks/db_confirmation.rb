# frozen_string_literal: true

module Isometric
  module RabbitHook
    class DbConfirmation
      DEFAULT_DB_MODEL = ::Isometric::OutboxMessage

      def process(_delivery_info, properties, body)
        DEFAULT_DB_MODEL.ack!(properties[:correlation_id], properties[:app_id], body)
      end
    end
  end
end
