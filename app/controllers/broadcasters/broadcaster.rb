module Broadcasters
  class Broadcaster
    include Services::Broadcasters::BroadcastMethod

    def initialize(broadcastable)
      @broadcastable = broadcastable
    end

    def broadcast
      @broadcastable.broadcast
    end
  end
end