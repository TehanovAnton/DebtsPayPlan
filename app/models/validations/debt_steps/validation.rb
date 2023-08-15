# frozen_string_literal: true

module Validations
  module DebtSteps
    module Validation
      EMPTY_PAY_VALUE = 'could not be empty'
      NEGATIVE_PAY_VALUE = 'cant be equal and less then zero'
      WRONG_NUMBER = 'should not has more then three-digit before decimal point and more then two digits after'

      extend ActiveSupport::Concern

      included do
        validates :group_debts_pay_plan, :debter, :recipient, presence: true

        validates :pay_value, presence: {
          message: EMPTY_PAY_VALUE
        }

        validates :pay_value, numericality: {
          greater_than: 0,
          message: NEGATIVE_PAY_VALUE
        }

        validates :pay_value, numericality: {
          less_than: 1000,
          message: WRONG_NUMBER
        }

        validates_with Validations::DebtSteps::DebterDebtsToRecipientValidator, on: :create
      end
    end
  end
end
