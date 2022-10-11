# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Isometric::RabbitJsonPublisher do
  describe 'initialize' do
    before do
      @instance = described_class.new('queue_name', nil, nil)
    end

    {
      exchange_name: 'direct_name',
      queue_name: 'queue_name',
      settings: {}
    }.each do |prop, expected|
      it "sets the #{prop} to #{expected}" do
        expect(@instance.send(prop)).to eq(expected)
      end
    end

    describe '.publish' do
      before do
        @settings = {
          my_setting: proc { 'value' }
        }
        @instance = described_class.new('queue_name', nil, nil, @settings)
        allow(@instance.exchange).to receive(:publish)
      end

      it 'evaluates the settings' do
        expect(Isometric::Config).to receive(:evaluate_hash).with(@settings).and_return(
          { my_setting: 'value' }
        )
        @instance.publish {}
      end
    end
  end
end
