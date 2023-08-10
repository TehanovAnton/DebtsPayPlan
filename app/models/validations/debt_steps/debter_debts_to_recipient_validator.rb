# frozen_string_literal: true

module Validations
  module DebtSteps
    class DebterDebtsToRecipientValidator < ActiveModel::Validator
      attr_reader :debt_step

      VALIDATION_ERROR_MESSAGE = 'debter should debts to recipient'

      def validate(debt_step)
        @debt_step = debt_step

        add_error(VALIDATION_ERROR_MESSAGE) unless debter_debts_to_recipient?
      end

      private

      def debter_debts_to_recipient?
        user_debt_value(debter) < user_debt_value(recipient)
      end

      def add_error(message)
        debt_step.errors.add(:base, message)
      end

      def user_debt_value(user)
        user.group_user_debt(group).debt_value
      end

      def group
        debt_step.group
      end

      def debter
        debt_step.debter
      end

      def recipient
        debt_step.recipient
      end
    end
  end
end
