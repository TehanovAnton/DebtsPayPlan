# frozen_string_literal: true

module Validations
  module GroupDebtsPayPlan
    module Validation
      extend ActiveSupport::Concern

      included do
        validates :group_debts_pay_plan_member, :group, presence: true
      end
    end
  end
end

class GroupDebtsPayPlan < ApplicationRecord
  include Validations::GroupDebtsPayPlan::Validation

  has_one :group_debts_pay_plan_member,
          as: :group_memberable,
          dependent: :destroy
  has_one :group,
          through: :group_debts_pay_plan_member
  has_many :debt_steps,
           dependent: :destroy
end
