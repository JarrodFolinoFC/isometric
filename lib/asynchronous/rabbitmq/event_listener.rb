# frozen_string_literal: true

require_relative '../base_event_listener'
require 'json'

module Isometric
  class EventListener < Isometric::BaseEventListener
    def listen
      queue.subscribe(block: true) do |_delivery_info, _metadata, payload|
        yield(payload)
      end
    end
  end
end
