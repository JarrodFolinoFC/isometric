# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Isometric::SchemaSummary do
  before do
    @s = described_class.from_convention("#{__dir__}/schemas/person.json")
  end

  it 'creates a shortcut method' do
    expect(@s.title).to eq('Person')
  end

  it 'creates a method for the mandatory fields' do
    expect(@s.required_fields).to eq(%w[uuid firstName lastName])
  end

  it 'creates a method for the optional fields' do
    expect(@s.optional_fields).to eq(%w[middleName])
  end

  it 'creates a method for the fields' do
    expect(@s.fields).to eq(%w[uuid firstName middleName lastName])
  end

  it 'fetches the field type' do
    expect(@s.type('firstName')).to eq('string')
  end
end
