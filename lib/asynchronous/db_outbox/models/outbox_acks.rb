# frozen_string_literal: true

require 'active_record'

module Isometric
  class OutboxAck < ActiveRecord::Base
  end
end
