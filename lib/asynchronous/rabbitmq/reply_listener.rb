# frozen_string_literal: true

require_relative '../base_event_listener'
require 'json'

module Isometric
  class ReplyListener < Isometric::BaseEventListener
    ::Citation.add(:messaging)
    def listen
      queue.subscribe(block: true) do |_delivery_info, _metadata, payload|


      end

      # listen for the reply which is a queue with the same name as correlation-id
      queue.channel
      channel.close
      channel.connection.close
    end
  end
end
