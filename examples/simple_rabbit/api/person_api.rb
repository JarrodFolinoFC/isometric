# frozen_string_literal: true

require 'active_record'
require 'grape-swagger'
require 'grape'

require_relative '../../../lib/isometric'

%w[db bunny default_publish_attributes redis logger queues].each do |file|
  require_relative "../config/#{file}"
end

require_relative '../models/person'

Isometric::DbConnection.connect_with_default!
Isometric::Discovery::RegistryFactory.instance.set('app/person_rest_server', 'http://localhost:4567')

module API
  class Person < Grape::API
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
        requires :first_name, type: String, desc: 'First Name.'
        requires :last_name, type: String, desc: 'Last Name.'
      end
      post do
        corr_id = ::Isometric::PublisherFactory.instance(
          queue_name: Isometric::Config.instance['person_queues'][:create],
          isometric_lookup: Isometric::DEFAULT_BUNNY_PUBLISH_KEY).publish do
          {
            first_name: params[:first_name],
            last_name: params[:last_name]
          }.to_json
        end
        { correlation_id: corr_id }
      end

      desc 'Update a person.'
      params do
        requires :uuid, type: String, desc: 'UUID.'
        requires :first_name, type: String, desc: 'First Name.'
        requires :last_name, type: String, desc: 'Last Name.'
        optional :middle_name, type: String, desc: 'Middle Name.'
      end
      put do
        corr_id = Isometric::PublisherFactory.instance(
            queue_name: Isometric::Config.instance['person_queues'][:update],
            isometric_lookup: Isometric::DEFAULT_BUNNY_PUBLISH_KEY).publish do
          {
            uuid: params[:uuid], first_name: params[:first_name],
            last_name: params[:last_name]
          }.to_json
        end
        { correlation_id: corr_id }
      end

      desc 'Delete a person.'
      params do
        requires :uuid, type: String, desc: 'UUID.'
      end
      post ':uuid' do
        corr_id = Isometric::PublisherFactory.instance(
            queue_name: Isometric::Config.instance['person_queues'][:delete],
            isometric_lookup: Isometric::DEFAULT_BUNNY_PUBLISH_KEY).publish do
          {
            uuid: params[:uuid]
          }.to_json
        end
        { correlation_id: corr_id }
      end
    end
  end
end
