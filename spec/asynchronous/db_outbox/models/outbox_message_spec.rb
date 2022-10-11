# frozen_string_literal: true

require 'active_record'
module Isometric
  class OutboxMessage < ActiveRecord::Base
    has_many :outbox_acks

    def self.ack!(correlation_id, application_name, message)
      outbox_message = OutboxMessage.find_by!(correlation_id: correlation_id)
      OutboxAck.create!(outbox_message_id: outbox_message,
                        application_name: application_name,
                        message: message)
    end
  end
end
