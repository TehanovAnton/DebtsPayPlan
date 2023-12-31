# frozen_string_literal: true

module Creaters
  module CostsCreaters
    class CostCreater < BaseCostCreater
      include Dry::Monads[:result]

      attr_reader :costable, :cost_value, :group, :debt

      def initialize(costable, cost_value, group, debt)
        super()

        @costable = costable
        @cost_value = cost_value
        @group = group
        @debt = debt
      end

      def create
        super

        if cost.valid?
          Success(cost)
        else
          Failure(cost.errors)
        end
      end

      private

      def cost
        @cost ||= Cost.create(
          costable:,
          cost_value:,
          debt:,
          group:
        )

        @cost
      end
    end
  end
end
