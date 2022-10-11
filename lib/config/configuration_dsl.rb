# frozen_string_literal: true

require 'pry'
module Isometric
  class ConfigurationDSL
    attr_reader :config, :namespace, :namespace_stack

    def initialize
      @config = {}
      @namespace = @config
      @namespace_stack = []
    end

    def nested(name, &block)
      @namespace_stack += [name]
      # build_namespace
      @config[name] = {} unless @config[name]
      @namespace = @config[name]
      block.call
      @namespace_stack = @namespace_stack[0, @namespace_stack.size - 1] unless @namespace_stack.empty?
      @namespace = @config
    end

    def respond_to_missing?
      true
    end

    def method_missing(method_name, *args, &block)
      namespace[method_name] = if block_given?
                                 proc { |*proc_args| block.call(*proc_args) }
                               else
                                 args.first
                               end
    end
  end
end
