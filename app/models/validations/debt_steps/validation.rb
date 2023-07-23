# frozen_string_literal: true

module Validations
  module DebtSteps
    module Validation
      extend ActiveSupport::Concern

      included do
        validates :group_debts_pay_plan, :debter, :recipient, presence: true
        validates_with Validations::DebtSteps::DebterDebtsToRecipientValidator
      end
    end
  end
end
