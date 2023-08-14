# frozen_string_literal: true

module Services
  module DebtSteps
    FROM_FIELDS = %i[debter_id recipient_id group_debts_pay_plan_id pay_value].freeze

    class CreateFormFieldsSaver
      attr_reader :debt_step

      def initialize(debt_step)
        @debt_step = debt_step
      end

      def form_fields
        fields = Services::DebtSteps::FROM_FIELDS

        debt_step.attributes.select do |key, _|
          fields.include?(key.to_sym)
        end
      end
    end
  end
end
