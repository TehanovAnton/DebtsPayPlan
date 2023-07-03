module Seeds
  module Builders
    module Costs
      class CostBuilder
        def initialize(costable, cost_value: 0)
          @cost_value = cost_value
          @costable = costable
        end

        def result
          create
          @seed
        end

        def create
          return @seed if @seed

          @seed = FactoryBot.create(:cost, costable: @costable, cost_value: @cost_value)
        end
      end

      class GroupCostAttributesBuilder < Builders::Builder
        def make_seed
          return @seed if @seed

          @seed = factory_bot_named_attributes
        end
      end
    end
  end
end
