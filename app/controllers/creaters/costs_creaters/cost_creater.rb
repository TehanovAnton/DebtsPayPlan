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
      end
    end
  end
end
