# frozen_string_literal: true

module Broadcasters
  module Targets
    module TargetMethod
      def target
        raise StandardError, 'not implemented'
      end
    end
  end
end
