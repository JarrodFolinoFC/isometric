module Isometric
  class Saga
    def initialize(chain, headers: {})
      @chain = chain
      @headers = headers
      @rollback_chain = []
    end

    def commit(uuid, payload)
      @uuid = uuid
      @payload = payload
      begin
        @chain.each do |chain|
          chain_instance = chain.new(@uuid, @payload, @headers)
          @uuid, @payload = chain_instance.commit
          @rollback_chain.unshift(chain_instance)
        end
      end
    rescue
      @rollback_chain.each do |chain_link|
        chain_link.rollback
      end
    end
  end
end