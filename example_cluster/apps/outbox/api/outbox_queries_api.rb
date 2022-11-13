# frozen_string_literal: true

require_relative 'outbox_api_shared_config'

Isometric::DbConnection.from_convention
# Isometric::Discovery::RegistryFactory.instance.set('app/person_rest_server', 'http://localhost:4567')

module API
  class OutboxQueries < Grape::API
    version GLOBAL_SC.version, using: :header, vendor: GLOBAL_SC.vendor
    format :json
    prefix :api

    desc "Return all #{GLOBAL_SC.friendly_name}s."
    get "#{GLOBAL_SC.friendly_name}s" do
      GLOBAL_SC.schema_class.limit(20)
    end

    resource GLOBAL_SC.friendly_name do
      desc "Return a #{GLOBAL_SC.friendly_name}."
      params do
        details = GLOBAL_SC.schema.details(GLOBAL_SC.uuid.to_s)
        requires(details[:name], type: details[:type], desc: details[:description])
      end
      route_param GLOBAL_SC.uuid do
        get do
          GLOBAL_SC.schema_class.find_by(uuid: params[GLOBAL_SC.uuid])
        end
      end
    end
  end
end
