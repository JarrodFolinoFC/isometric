# frozen_string_literal: true

require 'json'

module Listener
  module SportingEvent
    class Created < ::Isometric::BaseEventListener
      def listen(_delivery_info, _metadata, payload)
        Isometric::Logger.instance.debug("#{self.class} called")
        sporting_events = ::Isometric::ActiveModelHelper.build_all(::SportingEvent, JSON.parse(payload))
        sporting_events.map(&:save!)
        Isometric::Logger.instance.debug("#{sporting_events.size} SportingEvent objects created")
      end
    end
  end
end
