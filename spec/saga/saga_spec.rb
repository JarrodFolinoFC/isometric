# frozen_string_literal: true

require 'spec_helper'
require_relative 'global_state'

RSpec.describe Isometric::Saga do
  before do
    GlobalState.reset

    class ChainItem
      def initialize(uuid, payload, headers)
        @uuid = uuid
        @payload = payload
      end

      def commit
        GlobalState.add(@uuid, @payload)
        ["uuid#{@payload + 1}", @payload + 1]
      end

      def rollback
        GlobalState.remove(@uuid)
      end
    end

    class Bang
      def initialize(uuid, payload, headers)
        @uuid = uuid
        @payload = payload
      end

      def commit
        raise 'bang'
      end

      def rollback

      end
    end
  end

  it 'commits' do
    @saga = described_class.new([ChainItem, ChainItem, ChainItem])
    @saga.commit('uuid1', 1)
    expect(GlobalState.state).to eq({ "uuid1" => 1, "uuid2" => 2, "uuid3" => 3 })
  end

  it 'rollsback' do
    @saga = described_class.new([ChainItem, ChainItem, ChainItem, Bang])
    expect(GlobalState.state).to eq({})
  end
end
