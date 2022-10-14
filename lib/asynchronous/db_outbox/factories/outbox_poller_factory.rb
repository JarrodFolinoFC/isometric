# frozen_string_literal: true

module Isometric
  module OutboxPollerFactory
    DEFAULT_DB_MODEL = OutboxMessage
    DEFAULT_PUBLISHER = ::Isometric::OutboxPublisherFactory

    def self.instance(isometric_lookup: nil, db_model: nil, publisher_factory: nil)
      isometric_config = Isometric::Config.instance[isometric_lookup]
      Isometric::OutboxPoller.new(
        isometric_config['db_model'] || db_model || DEFAULT_DB_MODEL,
        isometric_config['publisher_factory'] || publisher_factory&.new(queue) || DEFAULT_PUBLISHER.instance(queue)
      )
    end

    def self.from_convention
      instance(isometric_lookup: nil, db_model: DEFAULT_DB_MODEL,
               publisher_factory: DEFAULT_PUBLISHER)
    end
  end
end
