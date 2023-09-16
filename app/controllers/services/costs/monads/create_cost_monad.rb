# frozen_string_literal: true

module Services
  module Costs
    module Monads
      class CreateCostMonad < BaseCostMonad
        def monad
          @director.create
        end
      end
    end
  end
end
