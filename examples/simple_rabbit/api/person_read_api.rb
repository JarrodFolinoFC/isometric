# frozen_string_literal: true

require 'active_record'
require 'grape-swagger'
require 'grape'

require_relative '../../../lib/isometric'

%w[db bunny default_publish_attributes redis logger queues].each do |file|
  require_relative "../config/#{file}"
end

require_relative '../models/person'

Isometric::DbConnection.from_convention
Isometric::Discovery::RegistryFactory.instance.set('app/person_rest_server', 'http://localhost:4567')
SCHEMAS = Isometric::SchemaSummary.from_convention("#{__dir__}/../schemas")
UUID_FIELD = 'uuid'

module API
  class PersonRead < Grape::API
    QUEUE_CONFIG_REFERENCE = Isometric::Config.instance['person_queues']

    version 'v1', using: :header, vendor: 'acme'
    format :json
    prefix :api

    desc 'Return all people.'
    get :persons do
      ::Person.limit(20)
    end

    resource :person do
      desc 'Return a person.'
      params do
        requires UUID_FIELD, type: String, desc: 'UUID.'
      end
      route_param UUID_FIELD do
        get do
          ::Person.find_by(uuid: params[:uuid])
        end
      end
    end
  end
end
