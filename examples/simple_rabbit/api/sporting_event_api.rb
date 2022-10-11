# frozen_string_literal: true

require 'active_record'
require 'grape-swagger'
require 'grape'

require_relative '../../../lib/isometric'

%w[db bunny default_publish_attributes redis logger].each do |file|
  require_relative "../config/#{file}"
end

require_relative '../models/sporting_event'

Isometric::DbConnection.connect_with_default!
Isometric::Discovery::RegistryFactory.instance.set('app/sporting_event_rest_server', 'http://localhost:4567')

module API
  class SportingEvent < Grape::API
    version 'v1', using: :header, vendor: 'acme'
    format :json
    prefix :api

    desc 'Return all sporting events.'
    get :sporting_events do
      ::SportingEvent.limit(20)
    end

    resource :sporting_event do
      desc 'Return a sporting event.'
      params do
        requires :internal_id, type: Integer, desc: 'Status ID.'
      end
      route_param :internal_id do
        get do
          ::SportingEvent.find_by(internal_id: params[:internal_id])
        end
      end

      desc 'Create a sporting event.'
      params do
        requires :internal_id, type: String, desc: 'Your status.'
        requires :name, type: String, desc: 'Your status.'
        requires :event_date, type: String, desc: 'Your status.'
        requires :venue, type: String, desc: 'Your status.'
        requires :location, type: String, desc: 'Your status.'
      end
      post do
        corr_id = ::Isometric::PublisherFactory.instance(
          queue_name: 'sporting_event_create',
          isometric_lookup: Isometric::DEFAULT_BUNNY_PUBLISH_KEY).publish do
          {
            internal_id: params[:internal_id], name: params[:name],
            event_date: params[:event_date], venue: params[:venue],
            location: params[:location]
          }.to_json
        end
        { correlation_id: corr_id }
      end

      desc 'Update a sporting event.'
      params do
        requires :internal_id, type: String, desc: 'Your status.'
        optional :name, type: String, desc: 'Your status.'
        optional :event_date, type: String, desc: 'Your status.'
        optional :venue, type: String, desc: 'Your status.'
        optional :location, type: String, desc: 'Your status.'
      end
      put do
        corr_id = Isometric::PublisherFactory.instance(
            queue_name: 'sporting_event_update',
            isometric_lookup: Isometric::DEFAULT_BUNNY_PUBLISH_KEY).publish do
          {
            internal_id: params[:internal_id], name: params[:name],
            event_date: params[:event_date], venue: params[:venue],
            location: params[:location]
          }.to_json
        end
        { correlation_id: corr_id }
      end

      desc 'Delete a sporting event.'
      params do
        requires :internal_id, type: String, desc: 'Your status.'
      end
      post ':internal_id' do
        corr_id = Isometric::PublisherFactory.instance(
            queue_name: 'sporting_event_delete',
            isometric_lookup: Isometric::DEFAULT_BUNNY_PUBLISH_KEY).publish do
          {
            internal_id: params[:internal_id]
          }.to_json
        end
        { correlation_id: corr_id }
      end
    end
  end
end
