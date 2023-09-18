module Services
  module Costs
    module Definers
      class CostByIdDefiner
        include DefinerMethod

        def initialize(cost_id)
          @cost_id = cost_id
        end

        def define
          Cost.find(@cost_id)
        end
      end
    end
  end
end