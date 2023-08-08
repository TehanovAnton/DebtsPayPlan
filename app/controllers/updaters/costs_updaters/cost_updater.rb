# frozen_string_literal: true

module Updaters
  module CostsUpdaters
    class CostUpdater
      include Dry::Monads[:result]

      attr_reader :cost, :update_params

      def initialize(cost, update_params)
        @cost = cost
        @update_params = update_params
      end

      def update
        @cost.update(update_params)

        return Success(@cost) if @cost.valid?

        Failure(@cost.errors)
      end
    end
  end
end
