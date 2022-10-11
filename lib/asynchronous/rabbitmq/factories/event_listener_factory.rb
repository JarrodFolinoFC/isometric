# frozen_string_literal: true

module Isometric
  class EventListenerFactory
    DEFAULT_CLASS = Isometric::EventListener
    def self.instance(queue_name:, klass: nil, isometric_lookup: nil, settings: {})
      isometic_lookup_settings = Isometric::Config.instance[isometric_lookup]
      settings = isometic_lookup_settings.merge(settings) if isometic_lookup_settings
      @instances = {} if @instances.nil?
      conn = BunnyConnectionFactory.conn(isometric_lookup: Isometric::DEFAULT_BUNNY_CONNECTION_KEY)
      conn.start
      ch = conn.create_channel
      queue = ch.queue(queue_name, auto_delete: true)
      klass ||= DEFAULT_CLASS
      # one listener per queue
      @instances[queue_name] ||= klass.new(queue, settings)
    end
  end
end
