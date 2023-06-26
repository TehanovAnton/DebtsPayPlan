module Seeds
  module Models
    module Costs
      class CostSeed
        def initialize(user_seed, cost_value: 0)
          @user_seed = user_seed
          @cost_value = cost_value
        end

        def create
          @cost = FactoryBot.create(:cost, costable: @user_seed.create)
        end

        def group_cost_attributes
          {
            cost_value: @cost_value
          }
        end
      end
    end
  end
end
