# frozen_string_literal: true

require_relative 'person_api_shared_config'

Isometric::DbConnection.from_convention
Isometric::Discovery::RegistryFactory.instance.set('app/person_rest_server', 'http://localhost:4567')

module API
  class PersonWrite < Grape::API
    version SC::VERSION, using: :header, vendor: SC::VENDOR
    format :json
    prefix :api

    resource :person do
      desc 'Create a person.'
      params do
        SC::SCHEMA.required_fields.each do |field|
          details = SC::SCHEMA.details(field)
          requires(details[:name], type: details[:type], desc: details[:description])
        end
      end
      post do
        queue_name = SC::QUEUE_CONFIG_REFERENCE[:create]
        corr_id = ::Isometric::PublisherFactory.from_convention(
          queue_name: queue_name
        ).publish do
          { first_name: params[:first_name], last_name: params[:last_name] }
        end
        Isometric::Response.render_response(corr_id)
      end

      desc 'Update a person.'
      params do
        details = SC::SCHEMA.details(SC::UUID_FIELD)
        requires(details[:name], type: details[:type], desc: details[:description])

        ([SC::SCHEMA.fields] - [SC::UUID_FIELD]).each do |_field|
          details = SC::SCHEMA.details(SC::UUID_FIELD)
          optional(details[:name], type: details[:type], desc: details[:description])
        end
      end
      put do
        queue_name = SC::QUEUE_CONFIG_REFERENCE[:update]
        corr_id = Isometric::PublisherFactory.from_convention(queue_name: queue_name).publish do
          { uuid: params[SC::UUID_FIELD], first_name: params[:first_name], last_name: params[:last_name] }
        end
        Isometric::Response.render_response(corr_id)
      end

      desc 'Delete a person.'
      params do
        details = SC::SCHEMA.details(SC::UUID_FIELD.to_s)
        requires(details[:name], type: details[:type], desc: details[:description])
      end
      post ':uuid' do
        queue_name = SC::QUEUE_CONFIG_REFERENCE[:delete]
        factory = Isometric::PublisherFactory.from_convention(queue_name: queue_name)

        Isometric::Response.render_response(factory.publish do
          { uuid: params[SC::UUID_FIELD] }
        end)
      end
    end
  end
end
