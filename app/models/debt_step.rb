module Validations
  module DebtSteps
    class DebterDebtToRecipientValidator < ActiveModel::Validator
      attr_reader :debt_step

      def validate(debt_step)
        @debt_step = debt_step

        add_error('debter should debts to recipient') unless debter_debts_to_recipient?
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

    module Validation
      extend ActiveSupport::Concern

      included do
        validates :group_debts_pay_plan, :debter, :recipient, presence: true
        validates_with Validations::DebtSteps::DebterDebtToRecipientValidator
      end
    end
  end  
end

class DebtStep < ApplicationRecord
  include Validations::DebtSteps::Validation

  belongs_to :group_debts_pay_plan
  belongs_to :debter,
             class_name: 'User'
  belongs_to :recipient,
             class_name: 'User'

  delegate :group, to: :group_debts_pay_plan, allow_nil: true
end
