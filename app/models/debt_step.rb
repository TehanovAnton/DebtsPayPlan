# frozen_string_literal: true

class DebtStep < ApplicationRecord
  include Validations::DebtSteps::Validation

  belongs_to :group_debts_pay_plan
  belongs_to :debter,
             class_name: 'User'
  belongs_to :recipient,
             class_name: 'User'

  delegate :group, to: :group_debts_pay_plan, allow_nil: true
end
