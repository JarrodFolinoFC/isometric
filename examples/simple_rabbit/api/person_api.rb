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

module API
  class Person < Grape::API
    QUEUE_CONFIG_REFERENCE = Isometric::Config.instance['person_queues']

    version 'v1', using: :header, vendor: 'acme'
    format :json
    prefix :api

    desc 'Return all sporting events.'
    get :persons do
      ::Person.limit(20)
    end

    resource :person do
      desc 'Return a person.'
      params do
        requires :uuid, type: String, desc: 'UUID.'
      end
      route_param :uuid do
        get do
          ::Person.find_by(uuid: params[:uuid])
        end
      end

      desc 'Create a person.'
      params do
        [
          { name: :first_name, type: String, desc: '' },
          { name: :last_name, type: String, desc: '' }
        ].each do |e|
          requires(e[:name], type: e[:type], desc: e[:desc])
        end
      end
      post do
        queue_name = Isometric::Config.instance['person_queues'][:create]
        corr_id = ::Isometric::PublisherFactory.from_convention(
          queue_name: queue_name
        ).publish do
          { first_name: params[:first_name], last_name: params[:last_name] }
        end
        Isometric::Response.render_response(corr_id)
      end

      desc 'Update a person.'
      params do
        [
          { name: :uuid, type: String, desc: '' },
          { name: :first_name, type: String, desc: '' },
          { name: :last_name, type: String, desc: '' }
        ].each do |e|
          requires(e[:name], type: e[:type], desc: e[:desc])
        end
        optional :middle_name, type: String, desc: 'Middle Name.'
      end
      put do
        queue_name = Isometric::Config.instance['person_queues'][:update]
        corr_id = Isometric::PublisherFactory.from_convention(queue_name: queue_name).publish do
          {
            uuid: params[:uuid], first_name: params[:first_name], last_name: params[:last_name]
          }
        end
        Isometric::Response.render_response(corr_id)
      end

      desc 'Delete a person.'
      params do
        [{ name: :uuid, type: String, desc: '' }].each do |e|
          requires(e[:name], type: e[:type], desc: e[:desc])
        end
      end
      post ':uuid' do
        queue_name = Isometric::Config.instance['person_queues'][:delete]
        factory = Isometric::PublisherFactory.from_convention(queue_name: queue_name)
        corr_id = factory.publish { { uuid: params[:uuid] } }
        Isometric::Response.render_response(corr_id)
      end
    end
  end
end
