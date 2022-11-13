# frozen_string_literal: true

require 'spec_helper'

require_relative '../../config/db'
RSpec.describe 'simple flow' do
  include FactoryBot::Syntax::Methods
  include Rack::Test::Methods

  let(:params) { create(:outbox_message) }

  describe 'GET /api/outbox_message', type: %w[activerecord rack] do
    before do
      Isometric::OutboxMessage.create(FactoryBot.build(:outbox_message, uuid: 'uuid1'))
      Isometric::OutboxMessage.create(FactoryBot.build(:outbox_message, uuid: 'uuid2'))
    end

    it 'fetches the outbox messages' do
      result = get('/api/outbox_messages')
      body = JSON.parse(result.body)
      expect(body.map { |e| e['uuid'] }).to eq(%w[uuid1 uuid2])
    end
  end

  describe 'GET /api/outbox_message', type: %w[activerecord rack] do
    before do
      Isometric::OutboxMessage.create(FactoryBot.build(:outbox_message, uuid: 'uuid1'))
    end

    it 'fetches the outbox_message' do
      result = get('/api/outbox_message/uuid1')
      body = JSON.parse(result.body)
      expect(body['uuid']).to eq('uuid1')
    end
  end

  describe 'POST /api/outbox_message', type: %w[activerecord rack] do
    before do
      post('/api/outbox_message', params)
    end

    it 'creates 1 outbox message' do
      expect(Isometric::OutboxMessage.count).to eq(1)
    end

    [
      { prop: 'uuid', value: 'uuid1' },
      { prop: 'correlation_id', value: 'corr1' },
      { prop: 'queue', value: 'queue1' },
      { prop: 'model', value: 'Model' },
      { prop: 'app_id', value: 'app' },
      { prop: 'status', value: 'new' },
      { prop: 'model', value: 'Model' },
      { prop: 'headers', value: "{\"something\"=>\"else\"}" },
      { prop: 'payload', value: "{\"data\"=>\"else\"}" }
    ].each do |tc|
      it "sets the #{tc[:prop]}" do
        expect(Isometric::OutboxMessage.last.send(tc[:prop])).to eq(tc[:value])
      end
    end
  end

  describe 'PUT /api/outbox_message', type: %w[rack activerecord] do
    before do
      @outbox_message = Isometric::OutboxMessage.create(params)
      put('/api/outbox_message', {
        'uuid' => @outbox_message.uuid, 'status' => 'processing'
      })
    end

    it 'updates the status' do
      expect(Isometric::OutboxMessage.last.status).to eq('processing')
    end
  end

  # describe 'DELETE /api/address', type: %w[rack activerecord] do
  #   before do
  #     address = Address.create(params)
  #     post("/api/address/#{address.uuid}")
  #     run_poller_once('db/address/delete', Listener::Address::Deleted)
  #   end
  #
  #   it 'creates 1 outbox message' do
  #     expect(Isometric::OutboxMessage.count).to eq(1)
  #   end
  #
  #   it 'creates 1 ack' do
  #     expect(Isometric::OutboxAck.count).to eq(1)
  #   end
  #
  #   it 'deletes 1 address' do
  #     expect(Address.count).to eq(0)
  #   end
  # end
end
