# frozen_string_literal: true

module Isometric
  module OutboxPublisherFactory
    def self.instance(queue_name:, isometric_lookup: nil, settings: {})
      config = Isometric::Config.instance[isometric_lookup] || {}
      @instances = {} if @instances.nil?
      @instances[queue_name] ||= Isometric::OutboxPublisher.new(queue_name, config[:settings].merge(settings))
    end
  end
end
