# frozen_string_literal: true

module Services
  module Costs
    module Monads
      class BaseCostMonad
        include MonadsMethod

        def initialize(director)
          @director = director
        end
      end
    end
  end
end
