# frozen_string_literal: true

module Isometric
  module OutboxHooks
    CONFIRMATION = proc do |_delivery_info, properties, _body|
      DEFAULT_DB_MODEL.ack!(properties[:correlation_id], properties[:app_id], body)
    end

    CLOSE = proc do |_queue, _delivery_info, _properties, _body|
      raise 'error'
    end
  end
end
