# frozen_string_literal: true

require 'spec_helper'
require_relative 'sample_config'

Isometric::Config.instance.set_config('config1') do
  simple_value 'simple_value'
  overidden_value 'overidden_value1'
  overidden_value 'overidden_value2'
  nested(:child) do
    value 'childvalue'
  end
  after_nest_value 'toplevel'
  nested(:child) do
    value2 'childvalue2'
  end
end

RSpec.describe Isometric::Config do
  after do
    described_class.clean
  end

  describe 'config' do
    before do
      Isometric::Config.instance.set_config(config_name) do
        simple_value 'simple_value'
        overidden_value 'overidden_value1'
        overidden_value 'overidden_value2'
        nested(:child) do
          value 'childvalue'
        end
        after_nest_value 'toplevel'
        nested(:child) do
          value2 'childvalue2'
        end
      end
    end

    let(:config_name) { 'config1' }
    let(:config) do
      Isometric::Config.instance
    end

    it 'sets a simple value' do
      expect(config[config_name][:simple_value]).to eq('simple_value')
    end

    it 'overrides a value' do
      expect(config[config_name][:overidden_value]).to eq('overidden_value2')
    end

    it 'sets a namespaced value' do
      expect(config[config_name][:child][:value]).to eq('childvalue')
    end

    it 'sets a namespaced value for a namespace already declared' do
      expect(config[config_name][:child][:value2]).to eq('childvalue2')
    end

    it 'the namespace returns to the top level after the nested' do
      expect(config[config_name][:after_nest_value]).to eq('toplevel')
    end
  end
end
