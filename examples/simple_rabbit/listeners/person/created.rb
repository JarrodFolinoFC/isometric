# frozen_string_literal: true

require 'json'

module Listener
  module Person
    class Created < ::Isometric::BaseEventListener
      def listen(_delivery_info, _metadata, payload)
        Isometric::Logger.instance.debug("#{self.class} called")
        persons = ::Isometric::ActiveModelHelper.build_all(::Person, JSON.parse(payload))
        persons.map(&:save!)
        Isometric::Logger.instance.debug("#{persons.size} Person objects created")
      end
    end
  end
end
