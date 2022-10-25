# frozen_string_literal: true

require_relative 'configuration_dsl'

module Isometric
  class Config
    Citation.add(:externalized_configuration)
    def self.instance
      @instance ||= Isometric::Config.new
    end

    def self.clean
      @instance = nil
    end

    def self.evaluate_hash(hash)
      new_map = {}
      hash.map do |k, v|
        new_map[k] = v.instance_of?(Proc) ? v.call : v
      end
      new_map
    end

    def initialize
      @config = {}
      @tags = []
    end

    def all
      @config
    end

    def [](key)
      @config[key]
    end

    def set_config(key, tags = [], &block)
      return if @config.key?(key)

      @tags = tags
      @configuration_dsl = ConfigurationDSL.new
      @configuration_dsl.instance_eval(&block)

      @config[key] = @configuration_dsl.config
    end

    def app_config(&block)
      set_config('app', &block)
    end
  end
end
