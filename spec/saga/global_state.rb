class GlobalState
  def self.state
    @state ||= {}
  end

  def self.add(uuid, payload)
    state[uuid] = payload
  end

  def self.remove(uuid)
    state.delete!(uuid)
  end

  def self.reset
    @state = {}
  end
end