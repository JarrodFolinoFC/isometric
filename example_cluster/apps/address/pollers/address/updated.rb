# frozen_string_literal: true

require 'json'

module Listener
  module Address
    class Updated < ::Isometric::BaseOutboxPoller
      def process(outbox_message)
        payload = JSON.parse(outbox_message.payload)
        model = Object.const_get(outbox_message.model).find_by(uuid: payload['uuid'])
        model.update(payload)
      end
    end
  end
end
