# frozen_string_literal: true

module Services
  module Costs
    module Setters
      class NewCostSetter < BaseSetter
        def set
          @cost = @definer.define
        end
      end
    end
  end
end
