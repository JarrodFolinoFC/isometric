# frozen_string_literal: true

require_relative 'address_api_shared_config'

module API
  class AddressQueries < Grape::API
    version SC::VERSION, using: :header, vendor: SC::VENDOR
    format :json
    prefix :api

    desc "Return all #{SC::FRIENDLY_NAME}s."
    get "#{SC::FRIENDLY_NAME}es" do
      SC::SCHEMA_CLASS.limit(20)
    end

    resource SC::FRIENDLY_NAME do
      desc "Return a #{SC::FRIENDLY_NAME}."
      params do
        details = SC::SCHEMA.details(SC::UUID_FIELD.to_s)
        requires(details[:name], type: details[:type], desc: details[:description])
      end
      route_param SC::UUID_FIELD do
        get do
          SC::SCHEMA_CLASS.find_by(uuid: params[SC::UUID_FIELD])
        end
      end
    end
  end
end
