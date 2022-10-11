# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Citation do
  Citation.set_root

  class Car
    Citation.create(:singleton, ['https://springframework.guru/gang-of-four-design-patterns/'])
    Citation.add(:singleton)
    def self.instance
      @instance ||= Car.new
    end
  end

  it 'sets the root' do
    expect(Citation.root).to eq('/Users/jarrod.folino/Dev/research/myarch/libs/isometric/spec/citations')
  end

  it 'adds to the encyclopedia' do
    expect(described_class.encyclopedia[:singleton][:references].first)
      .to eq('/citation_spec.rb:10:in <class:Car>')
  end
end
