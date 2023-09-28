# frozen_string_literal: true

module Services
  module Broadcasters
    module BroadcastMethod
      def broadcast
        raise StandardError, 'not implemented'
      end
    end
  end
end
