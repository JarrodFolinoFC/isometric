# frozen_string_literal: true

require_relative 'models/outbox_message'
module Isometric
  class OutboxPublisher
    def initialize(queue_name:, model:, outbox_model:, headers: nil, settings: nil, app_id:)
      @queue_name = queue_name
      @outbox_model = outbox_model
      @model = model
      @app_id = app_id
      @headers = headers
      @settings = settings
    end

    def publish
      payload = yield
      create_outbox_record(payload)
    end

    def publish_model(model)
      create_outbox_record(model.attributes)
    end

    private

    def create_outbox_record(payload)
      settings = Isometric::Config.evaluate_hash(@settings) if @settings
      headers_hash = Isometric::Config.evaluate_hash(@headers) if @headers
      @outbox_model.create!(
        queue: @queue_name,
        payload: payload.to_json,
        headers: headers_hash.to_json,
        app_id: @app_id,
        model: @model,
        correlation_id: settings[:correlation_id]
      )
      {
        correlation_id: settings[:correlation_id],
        uuid: @outbox_model
      }
    end
  end
end
