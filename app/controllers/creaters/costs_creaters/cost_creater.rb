# frozen_string_literal: true

module Creaters
  module CostsCreaters
    class CostCreater < BaseCostCreater
      attr_reader :cost_params, :cost

      def initialize(cost_params)
        super()

        @cost_params = cost_params
      end

      def create
        @cost = Cost.create(cost_params)
      end
    end
  end
end
