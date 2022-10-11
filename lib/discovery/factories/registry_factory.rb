# frozen_string_literal: true

module Isometric
  module Discovery
    class RegistryFactory
      def self.instance
        config = Isometric::Config.instance.all['redis']
        redis = Redis.new(host: config[:host], port: config[:port])
        @instance ||= Isometric::Discovery::Registry.new(redis)
      end
    end
  end
end
