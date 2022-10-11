# frozen_string_literal: true

require 'json'

module Listener
  module SportingEvent
    class Deleted < ::Isometric::BaseEventListener
      def listen(_delivery_info, _metadata, payload)
        Isometric::Logger.instance.debug("#{self.class} called")
        internal_id = JSON.parse(payload)['internal_id']
        ::SportingEvent.find_by(internal_id: internal_id).delete
        Isometric::Logger.instance.debug("SportingEvent internal_id: #{internal_id} deleted")
      end
    end
  end
end
