# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Isometric::Logger do
  it 'returns a new instance of a logger for the given class' do
    expect(Isometric::Logger.instance).to_not be_nil
  end
end
