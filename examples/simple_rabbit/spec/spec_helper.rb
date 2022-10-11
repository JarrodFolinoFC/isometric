# frozen_string_literal: true

require 'rspec'
require 'rack'
require 'rack/test'
require 'json'
require 'timeout'
require 'database_cleaner/active_record'
require 'factory_bot'

require_relative '../../../lib/isometric'
require_relative '../api/root'

include Rack::Test::Methods

def app
  @app ||= Rack::Builder.parse_file("#{__dir__}/../api/config.ru")
end


DatabaseCleaner.strategy = :truncation

RSpec.configure do |c|
  c.include FactoryBot::Syntax::Methods

  c.before(:suite) do
    FactoryBot.find_definitions
  end

  c.around(:each, type: :activerecord) do |example|
    DatabaseCleaner.clean
    example.run
  end
end

RSpec.configure do |c|
  c.around(:each, type: :rabbitmq) do |example|
    Timeout.timeout(10) do
      example.run
    end
    ::Isometric::BunnyConnectionFactory.connections.each(&:close)
  end
end
