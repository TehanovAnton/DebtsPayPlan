# frozen_string_literal: true

FactoryBot.define do
  factory :group_debts_pay_plan do
    group {}

    group_debts_pay_plan_member do
      association(
        :group_debts_pay_plan_member,
        group_memberable: instance,
        group:
      )
    end
  end
end
