# frozen_string_literal: true

require_relative 'models/outbox_message'
require_relative 'factories/outbox_publisher_factory'

require 'json'

module Isometric
  class OutboxPoller
    attr_reader :db_model, :publisher_class

    def initialize(db_model = nil, publisher = nil)
      @db_model = db_model
      @publisher = publisher
    end

    def run
      Isometric::Logger.instance.info("#{self.class} started polling #{db_model}")
      loop do
        query = db_model.where(last_published_at: nil).or(db_model.where.not('updated_at != last_published_at'))
        query.each(&method(:process))
      end
    end

    def process(msg)
      publisher_class.instance(msg.queue).publish do
        msg.payload
      end
      msg.update(last_published_at: msg.updated_at)
    end
  end
end
