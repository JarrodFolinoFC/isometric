# frozen_string_literal: true

require 'spec_helper'

require_relative '../../config/db'
require_relative '../../pollers/address/created'
require_relative '../../pollers/address/updated'
require_relative '../../pollers/address/deleted'
require_relative '../../models/address'

def run_poller_once(queue, model)
  model.new(outbox_model: Isometric::OutboxMessage,
            selection_query: "select * from outbox_messages where queue = '#{queue}' and processed_at is null",
            settings: {
              after_hooks: [
                Isometric::OutboxHooks::CONFIRMATION,
                Isometric::OutboxHooks::CLOSE]
            }).call
rescue StandardError
  nil
end

RSpec.describe 'simple flow' do
  include FactoryBot::Syntax::Methods
  include Rack::Test::Methods

  let(:params) { create(:address) }

  describe 'GET /api/addresses', type: ['activerecord'] do
    before do
      Address.create(FactoryBot.build(:address, uuid: 'uuid1'))
      Address.create(FactoryBot.build(:address, uuid: 'uuid2'))
    end

    it 'fetches the persons' do
      result = get('/api/addresses')
      body = JSON.parse(result.body)
      expect(body.map { |e| e['uuid'] }).to eq(%w[uuid1 uuid2])
    end
  end

  describe 'GET /api/address', type: ['activerecord'] do
    before do
      Address.create(FactoryBot.build(:address, uuid: 'uuid1'))
    end

    it 'fetches the event' do
      result = get('/api/address/uuid1')
      body = JSON.parse(result.body)
      expect(body['uuid']).to eq('uuid1')
    end
  end

  describe 'POST /api/address', type: %w[activerecord rack] do
    before do
      post('/api/address', params)
      run_poller_once('db/address/create', Listener::Address::Created)
    end

    it 'creates 1 outbox message' do
      expect(Isometric::OutboxMessage.count).to eq(1)
    end

    it 'creates 1 ack' do
      expect(Isometric::OutboxAck.count).to eq(1)
    end

    it 'creates 1 address' do
      expect(Address.count).to eq(1)
    end
  end

  describe 'PUT /api/address', type: %w[rack activerecord] do
    before do
      @address = Address.create(params)
      @new_postcode = 'S1334'
      put('/api/address', { 'uuid' => @address.uuid, 'street' => @address.street,
                            'borough' => @address.borough, 'postcode' => @new_postcode })
      run_poller_once('db/address/update', Listener::Address::Updated)
    end

    it 'creates 1 outbox message' do
      expect(Isometric::OutboxMessage.count).to eq(1)
    end

    it 'creates 1 ack' do
      expect(Isometric::OutboxAck.count).to eq(1)
    end

    it 'updates the address' do
      expect(@address.reload.postcode).to eq(@new_postcode)
    end
  end

  describe 'DELETE /api/address', type: %w[rack activerecord] do
    before do
      address = Address.create(params)
      post("/api/address/#{address.uuid}")
      run_poller_once('db/address/delete', Listener::Address::Deleted)
    end

    it 'creates 1 outbox message' do
      expect(Isometric::OutboxMessage.count).to eq(1)
    end

    it 'creates 1 ack' do
      expect(Isometric::OutboxAck.count).to eq(1)
    end

    it 'deletes 1 address' do
      expect(Address.count).to eq(0)
    end
  end
end
