# frozen_string_literal: true

module Creaters
  module CostsCreaters
    class CostCreater < BaseCostCreater
      attr_reader :costable, :cost_value, :group, :debt, :cost

      def initialize(costable, cost_value, group, debt)
        super()

        @costable = costable
        @cost_value = cost_value
        @group = group
        @debt = debt
      end

      def create
        @cost = Cost.create(
          costable:,
          cost_value:,
          debt:,
          group:
        )

        group_user_step_state_creater.create
      end

      def group_user_step_state_creater
        @group_user_step_state_creater = Creaters::GroupUserStepStatesCreaters::GroupUserStepStateCreater.new(
          costable,
          group
        )
      end      
    end
  end
end
