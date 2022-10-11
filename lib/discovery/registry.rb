# frozen_string_literal: true

require 'redis'

module Isometric
  module Discovery
    class Registry
      def initialize(redis)
        @redis = redis
      end

      def set(name, props)
        @redis.set(name, props)
      end

      def get(name)
        @redis.get(name)
      end

      def summary(prefix)
        filtered_keys = @redis.keys.find_all { |key| key.start_with?(prefix) }
        filtered_keys.each_with_object({}) do |key, hash|
          hash[key] = get(key)
        end
      end

      def delete(name) end
    end
  end
end
