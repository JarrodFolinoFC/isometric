# frozen_string_literal: true

module Isometric
  class BaseEventListener
    attr_reader :queue

    def initialize(queue, settings = nil)
      @queue = queue
      @settings = settings
      @before_hooks = @settings[:before_hooks] # post reply
      @exception_hooks = @settings[:exception_hooks] # log to exception reporter, saga rollback
      @after_hooks = @settings[:after_hooks] # idempotent handler, saga chain
    end

    def call
      Isometric::Logger.instance.info("#{self.class} started on queue: #{@queue}")
      queue.subscribe(block: true) do |delivery_info, metadata, payload|
        @before_hooks&.each { |hook| hook.call(queue, delivery_info, metadata, payload) }
        listen(delivery_info, metadata, payload)
        Isometric::Logger.instance.info('Message Processed')
        @after_hooks&.each { |hook| hook.call(queue, delivery_info, metadata, payload) }
      end
    end
  end
end
