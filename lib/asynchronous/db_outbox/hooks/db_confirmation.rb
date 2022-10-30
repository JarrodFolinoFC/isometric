# frozen_string_literal: true

module Isometric
  module OutboxHooks
    CONFIRMATION = proc do |outbox_msg|
      outbox_msg.class.ack!(outbox_msg.correlation_id, outbox_msg.app_id, 'success')
    end

    CLOSE = proc do |_outbox_msg|
      raise 'error'
    end
  end
end
