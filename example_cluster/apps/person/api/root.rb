# frozen_string_literal: true

require_relative 'person_queries_api'
require_relative 'person_commands_api'
require 'grape-swagger'
require 'grape'

module API
  class Root < Grape::API
    format :json
    mount API::PersonQueries
    mount API::PersonCommands
    add_swagger_documentation hide_documentation_path: true,
                              api_version: 'v1',
                              info: {
                                title: 'API',
                                description: 'Person demo app'
                              }
  end
end
