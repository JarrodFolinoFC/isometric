# frozen_string_literal: true

require 'json'

module Listener
  module Address
    class Deleted < ::Isometric::BaseOutboxPoller
      def process(outbox_message)
        payload = JSON.parse(outbox_message.payload)
        Object.const_get(outbox_message.model).find_by(uuid: payload['uuid']).delete
      end
    end
  end
end
