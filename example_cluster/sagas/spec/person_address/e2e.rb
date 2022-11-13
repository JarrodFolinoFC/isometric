require 'spec_helper'

Isometric::EventListenerFactory.instance(queue_name: Isometric::Config.instance['person_queues'][channel],
                                         klass: listener,
                                         settings: { after_hooks:
                                                       [Isometric::RabbitHooks::PUBLISH_CONFIRMATION,
                                                        Isometric::RabbitHooks::CLOSE_CHANNEL] })

# webhook
# db acknowledge
# listen to response channel
# socket