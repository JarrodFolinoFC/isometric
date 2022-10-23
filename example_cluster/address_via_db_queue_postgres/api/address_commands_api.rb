# frozen_string_literal: true

require_relative 'address_api_shared_config'

module API
  class AddressCommands < Grape::API
    version SC::VERSION, using: :header, vendor: SC::VENDOR
    format :json
    prefix :api

    resource :address do
      desc 'Create an address.'
      params do
        SC::SCHEMA.required_fields.each do |field|
          details = SC::SCHEMA.details(field)
          requires(details[:name], type: details[:type], desc: details[:description])
        end
      end
      post do
        corr_id = ::Isometric::OutboxPublisherFactory
                  .from_convention(lookup_key: 'default/db/publish_attributes/create')
                  .publish { params }
        Isometric::Response.render_response(corr_id)
      end

      desc 'Update an address.'
      params do
        details = SC::SCHEMA.details(SC::UUID_FIELD)
        requires(details[:name], type: details[:type], desc: details[:description])

        ([SC::SCHEMA.fields] - [SC::UUID_FIELD]).each do |_field|
          details = SC::SCHEMA.details(SC::UUID_FIELD)
          optional(details[:name], type: details[:type], desc: details[:description])
        end
      end
      put do
        corr_id = ::Isometric::OutboxPublisherFactory
                  .from_convention(lookup_key: 'default/db/publish_attributes/update')
                  .publish { params }
        Isometric::Response.render_response(corr_id)
      end

      desc 'Delete an address.'
      params do
        details = SC::SCHEMA.details(SC::UUID_FIELD.to_s)
        requires(details[:name], type: details[:type], desc: details[:description])
      end
      post ':uuid' do
        corr_id = ::Isometric::OutboxPublisherFactory
                  .from_convention(lookup_key: 'default/db/publish_attributes/delete')
                  .publish { params }
        Isometric::Response.render_response(corr_id)
      end
    end
  end
end
