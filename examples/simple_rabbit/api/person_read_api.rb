# frozen_string_literal: true

require_relative 'person_api_shared_config'

Isometric::DbConnection.from_convention
Isometric::Discovery::RegistryFactory.instance.set('app/person_rest_server', 'http://localhost:4567')

module API
  class PersonRead < Grape::API
    version PersonApiSharedConfig::VERSION, using: :header, vendor: PersonApiSharedConfig::VENDOR
    format :json
    prefix :api

    desc "Return all #{PersonApiSharedConfig::FRIENDLY_NAME}s."
    get "#{PersonApiSharedConfig::FRIENDLY_NAME}s" do
      PersonApiSharedConfig::SCHEMA_CLASS.limit(20)
    end

    resource PersonApiSharedConfig::FRIENDLY_NAME do
      desc "Return a #{PersonApiSharedConfig::FRIENDLY_NAME}."
      params do
        requires PersonApiSharedConfig::UUID_FIELD, type: String, desc: PersonApiSharedConfig::UUID_FIELD.to_s
      end
      route_param PersonApiSharedConfig::UUID_FIELD do
        get do
          PersonApiSharedConfig::SCHEMA_CLASS.find_by(uuid: params[PersonApiSharedConfig::UUID_FIELD])
        end
      end
    end
  end
end
