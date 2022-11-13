# frozen_string_literal: true

require_relative 'outbox_queries_api'
require_relative 'outbox_commands_api'
require 'grape-swagger'
require 'grape'

module API
  class Root < Grape::API
    format :json
    mount API::OutboxCommands
    mount API::OutboxQueries
    add_swagger_documentation hide_documentation_path: true,
                              api_version: 'v1',
                              info: {
                                title: 'API',
                                description: 'Outbox demo app'
                              }
  end
end
