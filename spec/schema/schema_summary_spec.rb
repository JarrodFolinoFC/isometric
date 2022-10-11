# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Isometric::SchemaSummary do
  before do
    @s = described_class.from_convention("#{__dir__}/schemas/*json")
  end

  it 'parses the schema' do
    expect(@s.schemas['https://example.com/person.schema.json']['title']).to eq('Person')
  end

  it 'creates a shortcut method' do
    expect(@s.person_schema['title']).to eq('Person')
  end
end
