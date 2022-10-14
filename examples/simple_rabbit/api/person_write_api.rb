# frozen_string_literal: true

require_relative 'person_api_shared_config'

Isometric::DbConnection.from_convention
Isometric::Discovery::RegistryFactory.instance.set('app/person_rest_server', 'http://localhost:4567')

module API
  class PersonWrite < Grape::API
    version PersonApiSharedConfig::VERSION, using: :header, vendor: PersonApiSharedConfig::VENDOR
    format :json
    prefix :api

    resource :person do
      desc 'Create a person.'
      params do
        PersonApiSharedConfig::SCHEMA.person_schema_required_fields.map do |n|
          { name: n, type: String, desc: '' }
        end.each do |e|
          requires(e[:name], type: e[:type], desc: e[:desc])
        end
      end
      post do
        queue_name = PersonApiSharedConfig::QUEUE_CONFIG_REFERENCE[:create]
        corr_id = ::Isometric::PublisherFactory.from_convention(
          queue_name: queue_name
        ).publish do
          { first_name: params[:first_name], last_name: params[:last_name] }
        end
        Isometric::Response.render_response(corr_id)
      end

      desc 'Update a person.'
      params do
        [{ name: PersonApiSharedConfig::UUID_FIELD, type: String, desc: '' }].each do |e|
          requires PersonApiSharedConfig::UUID_FIELD, type: String, desc: PersonApiSharedConfig::UUID_FIELD
        end
        ([PersonApiSharedConfig::SCHEMA.person_schema_fields] - [PersonApiSharedConfig::UUID_FIELD]).map do |n|
          { name: n, type: String, desc: '' }
        end.each do |e|
          optional(e[:name], type: e[:type], desc: e[:desc])
        end
      end
      put do
        queue_name = PersonApiSharedConfig::QUEUE_CONFIG_REFERENCE[:update]
        corr_id = Isometric::PublisherFactory.from_convention(queue_name: queue_name).publish do
          { uuid: params[PersonApiSharedConfig::UUID_FIELD], first_name: params[:first_name], last_name: params[:last_name] }
        end
        Isometric::Response.render_response(corr_id)
      end

      desc 'Delete a person.'
      params do
        [{ name: PersonApiSharedConfig::UUID_FIELD, type: String, desc: '' }].each do |e|
          requires(e[:name], type: e[:type], desc: e[:desc])
        end
      end
      post ':uuid' do
        queue_name = PersonApiSharedConfig::QUEUE_CONFIG_REFERENCE[:delete]
        factory = Isometric::PublisherFactory.from_convention(queue_name: queue_name)
        corr_id = factory.publish { { uuid: params[PersonApiSharedConfig::UUID_FIELD] } }
        Isometric::Response.render_response(corr_id)
      end
    end
  end
end
