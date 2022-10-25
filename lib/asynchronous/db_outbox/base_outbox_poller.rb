# frozen_string_literal: true

require_relative 'models/outbox_message'
require_relative 'factories/outbox_publisher_factory'

require 'json'
require 'time'

module Isometric
  class BaseOutboxPoller
    ::Citation.add(:polling_publisher)

    attr_reader :outbox_model

    def initialize(outbox_model: nil, selection_query: nil, settings: {})
      @outbox_model = outbox_model
      @selection_query = selection_query
      @settings = settings
      @before_hooks = @settings[:before_hooks] # post reply
      @exception_hooks = @settings[:exception_hooks] # log to exception reporter, saga rollback
      @after_hooks = @settings[:after_hooks] # idempotent handler, saga chain
    end

    def call
      Isometric::Logger.instance.info("#{self.class} started polling #{outbox_model}")
      loop do
        # query = outbox_model.where(last_published_at: nil).or(outbox_model.where.not('updated_at != last_published_at'))
        query = outbox_model.find_by_sql(@selection_query)
        query.each do |model|
          @before_hooks&.each { |hook| hook.call(model) }
          do_process(model)
          @after_hooks&.each { |hook| hook.call(model) }
        end
      end
    end

    def do_process(model)
      process(model)
      model.update(processed_at: Time.new)
    end
  end
end
