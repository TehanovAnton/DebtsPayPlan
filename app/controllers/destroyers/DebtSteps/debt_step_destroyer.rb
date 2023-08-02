# frozen_string_literal: true

module Destroyers
  module DebtSteps
    class DebtStepDestroyer < Destroyer
      attr_reader :debt_step

      def initialize(debt_step)
        super()

        @debt_step = debt_step
      end

      def destroy_record
        debt_step.destroy
      end
    end
  end
end
