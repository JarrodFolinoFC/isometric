# frozen_string_literal: true

# require_relative 'address_queries_api'
require_relative 'address_commands_api'
require_relative 'address_queries_api'
require 'grape-swagger'
require 'grape'

require_relative 'address_api_shared_config'

Isometric::DbConnection.from_convention
# Isometric::Discovery::RegistryFactory.instance.set('app/address_rest_server', 'http://localhost:4567')

module API
  class Root < Grape::API
    format :json
    mount API::AddressCommands
    mount API::AddressQueries
    add_swagger_documentation hide_documentation_path: true,
                              api_version: 'v1',
                              info: {
                                title: 'API',
                                description: 'Address demo app'
                              }
  end
end
