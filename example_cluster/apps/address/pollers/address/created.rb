# frozen_string_literal: true

require 'json'

module Listener
  module Address
    class Created < ::Isometric::BaseOutboxPoller
      def process(outbox_message)
        payload = JSON.parse(outbox_message.payload)
        Object.const_get(outbox_message.model).create(payload)
      end
    end
  end
end
