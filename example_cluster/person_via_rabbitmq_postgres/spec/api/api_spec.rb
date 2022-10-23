# frozen_string_literal: true

require 'spec_helper'

require_relative '../../config/queues'
require_relative '../../listeners/person/created'
require_relative '../../listeners/person/deleted'
require_relative '../../listeners/person/updated'

def listener_af(listener, channel)
  Isometric::EventListenerFactory.instance(queue_name: Isometric::Config.instance['person_queues'][channel],
                                           klass: listener,
                                           settings: { after_hooks: [Isometric::RabbitHooks::CLOSE_CHANNEL] })
end

RSpec.describe 'simple flow' do
  let(:params) do
    create(:person)
  end

  describe 'GET /api/persons', type: ['activerecord'] do
    before do
      Person.create(FactoryBot.build(:person, uuid: 'uuid1'))
      Person.create(FactoryBot.build(:person, uuid: 'uuid2'))
    end

    it 'fetches the persons' do
      result = get('/api/persons')
      body = JSON.parse(result.body)
      expect(body.map { |e| e['uuid'] }).to eq(%w[uuid1 uuid2])
    end
  end

  describe 'GET /api/persons', type: ['activerecord'] do
    before do
      Person.create(FactoryBot.build(:person, uuid: 'uuid1'))
    end

    it 'fetches the event' do
      result = get('/api/person/uuid1')
      body = JSON.parse(result.body)
      expect(body['uuid']).to eq('uuid1')
    end
  end

  describe 'POST /api/persons', type: %w[rabbitmq activerecord] do
    let(:person_created_listener) { listener_af(Listener::Person::Created, :create) }

    before do
      post('/api/person', { 'last_name' => 'Jones', 'first_name' => 'Jon' })
      person_created_listener.call
    end

    it 'creates 1 event' do
      expect(Person.count).to eq(1)
    end
  end

  describe 'PUT /api/person', type: %w[rabbitmq activerecord] do
    let(:person_update_listener) { listener_af(Listener::Person::Updated, :update) }

    before do
      Person.create(params)
      put('/api/person', { 'uuid' => 'ewefrgweg3rethg34rty', 'last_name' => 'Jones', 'first_name' => 'Jon' })
      person_update_listener.call
    end

    it 'creates 1 event' do
      expect(Person.last.last_name).to eq('Jones')
    end
  end

  describe 'DELETE /api/person/delete', type: %w[rabbitmq activerecord] do
    let(:person_delete_listener) { listener_af(Listener::Person::Deleted, :delete) }

    before do
      Person.create(params)
      expect(Person.count).to eq(1)
      post('/api/person/ewefrgweg3rethg34rty')

      person_delete_listener.call
    end

    it 'deletes the event' do
      expect(Person.count).to eq(0)
    end
  end
end
