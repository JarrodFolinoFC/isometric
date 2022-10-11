# frozen_string_literal: true

require 'json'

module Listener
  module SportingEvent
    class Updated < ::Isometric::BaseEventListener
      def listen(_delivery_info, _metadata, payload)
        Isometric::Logger.instance.debug("#{self.class} called")
        data = JSON.parse(payload)
        internal_id = data['internal_id']
        sporting_event = ::SportingEvent.find_by(internal_id: internal_id)
        sporting_event.update!(data)
        Isometric::Logger.instance.debug("SportingEvent #{sporting_event.internal_id} updated")
      end
    end
  end
end
