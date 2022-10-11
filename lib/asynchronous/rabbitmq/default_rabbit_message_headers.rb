# frozen_string_literal: true

module Isometric
  class DefaultMessageAttributes
    HEADERS = %w[content-type content-encoding headers delivery-mode priority
                 correlation-id reply-to expiration message-id
                 timestamp type user-id app-id].freeze
  end
end
