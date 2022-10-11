# frozen_string_literal: true

require_relative 'sporting_event_api'
require 'grape-swagger'
require 'grape'

module API
  class Root < Grape::API
    format :json
    mount API::SportingEvent
    add_swagger_documentation hide_documentation_path: true,
                              api_version: 'v1',
                              info: {
                                title: 'API',
                                description: 'Demo app'
                              }
  end
end
