# frozen_string_literal: true

require 'json'

module Listener
  module PersonAddress
    class CreateAddressChainItem
      def initialize(uuid, payload, headers)
        @uuid = uuid
        @payload = payload
      end

      def commit
        corr_id = ::Isometric::OutboxPublisherFactory
                    .from_convention(lookup_key: 'default/db/publish_attributes/create')
                    .publish { params }
        # wait for success
        # set address uuid
        @address_uuid = nil
      end

      def rollback
        ::Isometric::OutboxPublisherFactory
          .from_convention(lookup_key: 'default/db/publish_attributes/delete')
          .publish { {uuid: @address_uuid } }
      end
    end

    class CreatePersonChainItem
      def initialize(uuid, payload, headers)
        @uuid = uuid
        @payload = payload
      end

      def commit
        corr_id = ::Isometric::PublisherFactory.from_convention(queue_name: QUEUES[:create]).publish { params }

        # wait for success
      end

      def rollback
      end
    end


    class Created < ::Isometric::BaseEventListener
      def listen(_delivery_info, _metadata, payload)
        Isometric::Logger.instance.debug("#{self.class} called")
        uuid = '1'
        payload = {}
        Isometric::Saga.new([CreateAddressChainItem, ]).commit(uuid, payload)
        Isometric::Logger.instance.debug("")
      end
    end
  end
end
