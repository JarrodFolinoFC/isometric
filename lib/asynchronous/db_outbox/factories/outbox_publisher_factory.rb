# frozen_string_literal: true

module Isometric
  module OutboxPublisherFactory
    def self.from_convention(lookup_key: nil)
      config = Isometric::Config.instance[lookup_key || ::Isometric::DEFAULT_DB_OUTBOX_PUBLISH_KEY]
      instance(queue_name: config[:queue_name],
               outbox_model: config[:outbox_model],
               model: config[:model],
               app_id:  config[:app_id],
               settings: config['settings'])
    end

    def self.instance(queue_name:, model:, outbox_model:, settings:, app_id:)
      Isometric::OutboxPublisher.new(queue_name: queue_name,
                                     outbox_model: outbox_model,
                                     model: model,
                                     app_id: app_id,
                                     settings: settings)
    end
  end
end
