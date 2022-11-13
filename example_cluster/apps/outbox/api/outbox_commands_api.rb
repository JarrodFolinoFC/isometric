# frozen_string_literal: true

require_relative 'outbox_api_shared_config'

Isometric::DbConnection.from_convention
# Isometric::Discovery::RegistryFactory.instance.set('app/outbox_rest_server', 'http://localhost:4567')

module API
  class OutboxCommands < Grape::API
    version GLOBAL_SC.version, using: :header, vendor: GLOBAL_SC.vendor
    format :json
    prefix :api

    resource GLOBAL_SC.friendly_name do
      desc 'Create an outbox message.'
      params do
        GLOBAL_SC.schema.required_fields.each do |field|
          details = GLOBAL_SC.schema.details(field)
          requires(details[:name], type: details[:type], desc: details[:description])
        end
      end
      post do
        ::Isometric::OutboxMessage.create(params)
      end

      desc 'Update an outbox message.'
      params do
        details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid)
        requires(details[:name], type: details[:type], desc: details[:description])
        optional('status', type: String, desc: 'status')
      end
      put do
        message = ::Isometric::OutboxMessage.find_by(uuid: params[:uuid])
        message.update({'status' => params[:status]})
      end

      # desc 'Delete a person.'
      # params do
      #   details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid.to_s)
      #   requires(details[:name], type: details[:type], desc: details[:description])
      # end
      # post ':uuid' do
      #   factory = Isometric::PublisherFactory.from_convention(queue_name: QUEUES[:delete])
      #
      #   Isometric::Response.render_response(factory.publish do
      #     { uuid: params[GLOBAL_SC.uuid] }
      #   end)
      # end
    end
  end
end
