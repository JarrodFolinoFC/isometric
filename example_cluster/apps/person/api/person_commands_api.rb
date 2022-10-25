# frozen_string_literal: true

require_relative 'person_api_shared_config'

Isometric::DbConnection.from_convention
Isometric::Discovery::RegistryFactory.instance.set('app/person_rest_server', 'http://localhost:4567')

module API
  class PersonCommands < Grape::API
    version GLOBAL_SC.version, using: :header, vendor: GLOBAL_SC.vendor
    format :json
    prefix :api

    resource :person do
      desc 'Create a person.'
      params do
        GLOBAL_SC.schema.required_fields.each do |field|
          details = GLOBAL_SC.schema.details(field)
          requires(details[:name], type: details[:type], desc: details[:description])
        end
      end
      post do
        corr_id = ::Isometric::PublisherFactory.from_convention(queue_name: QUEUES[:create]).publish { params }
        Isometric::Response.render_response(corr_id)
      end

      desc 'Update a person.'
      params do
        details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid)
        requires(details[:name], type: details[:type], desc: details[:description])

        ([GLOBAL_SC.schema.fields] - [GLOBAL_SC.uuid]).each do |_field|
          details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid)
          optional(details[:name], type: details[:type], desc: details[:description])
        end
      end
      put do
        corr_id = Isometric::PublisherFactory.from_convention(queue_name: QUEUES[:update]).publish { params }
        Isometric::Response.render_response(corr_id)
      end

      desc 'Delete a person.'
      params do
        details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid.to_s)
        requires(details[:name], type: details[:type], desc: details[:description])
      end
      post ':uuid' do
        factory = Isometric::PublisherFactory.from_convention(queue_name: QUEUES[:delete])

        Isometric::Response.render_response(factory.publish do
          { uuid: params[GLOBAL_SC.uuid] }
        end)
      end
    end
  end
end
