# frozen_string_literal: true

require 'json'

module Listener
  module Person
    class Updated < ::Isometric::BaseEventListener
      def listen(_delivery_info, _metadata, payload)
        Isometric::Logger.instance.debug("#{self.class} called")
        data = JSON.parse(payload)
        uuid = data['uuid']
        person = ::Person.find_by(uuid: uuid)
        person.update!(data)
        Isometric::Logger.instance.debug("Person #{person.uuid} updated")
      end
    end
  end
end
