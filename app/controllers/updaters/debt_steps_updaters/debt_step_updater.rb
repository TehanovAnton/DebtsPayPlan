# frozen_string_literal: true

module Updaters
  module DebtStepsUpdaters
    class DebtStepUpdater
      include Dry::Monads[:result]

      attr_reader :debt_step, :update_params

      def initialize(debt_step, update_params)
        @debt_step = debt_step
        @update_params = update_params
      end

      def update_monad
        @debt_step.update(update_params)

        return Success(@debt_step) if @debt_step.valid?

        Failure(@debt_step.errors)
      end
    end
  end
end
