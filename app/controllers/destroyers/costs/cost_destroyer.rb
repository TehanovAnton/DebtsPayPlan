# frozen_string_literal: true

module Destroyers
  module Costs
    class CostDestroyer
      include Dry::Monads[:maybe, :result]

      attr_reader :cost

      def initialize(cost)
        @cost = cost
      end

      def destroy
        destroy_monad
      end

      private

      def destroy_monad
        @destroy_monad ||= Maybe(@cost).maybe(&:destroy).to_result(&:destroy_error)
      end

      def destroy_error
        'Colud not detsroy cost'
      end
    end
  end
end
