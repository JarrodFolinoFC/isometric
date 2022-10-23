# frozen_string_literal: true

require 'json'

module Listener
  module Person
    class Deleted < ::Isometric::BaseEventListener
      def listen(_delivery_info, _metadata, payload)
        Isometric::Logger.instance.debug("#{self.class} called")
        uuid = JSON.parse(payload)['uuid']
        ::Person.find_by(uuid: uuid).delete
        Isometric::Logger.instance.debug("Person uuid: #{uuid} deleted")
      end
    end
  end
end
