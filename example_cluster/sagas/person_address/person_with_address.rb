module Isometric
  class Saga
    def chain
      [AddressChainLink, PersonChainLink]
    end
  end

  class PersonChainLink
    SC::QUEUES = Isometric::Config.instance['person_queues']
    def commit
      corr_id = ::Isometric::PublisherFactory.from_convention(queue_name: SC::QUEUES[:create]).publish { params }
    end

    def rollback
      corr_id = ::Isometric::PublisherFactory.from_convention(queue_name: SC::QUEUES[:delete]).publish { params }
    end
  end

  class AddressChainLink
    def commit

    end

    def rollback

    end
  end
end
