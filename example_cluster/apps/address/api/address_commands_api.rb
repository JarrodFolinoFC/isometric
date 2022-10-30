# frozen_string_literal: true

require_relative 'address_api_shared_config'

module API
  class AddressCommands < Grape::API
    version GLOBAL_SC.version, using: :header, vendor: GLOBAL_SC.vendor
    format :json
    prefix :api

    resource :address do
      desc 'Create an address.'
      params do
        GLOBAL_SC.schema.required_fields.each do |field|
          details = GLOBAL_SC.schema.details(field)
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
        details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid)
        requires(details[:name], type: details[:type], desc: details[:description])

        ([GLOBAL_SC.schema.fields] - [GLOBAL_SC.uuid]).each do |_field|
          details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid)
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
        details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid)
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
