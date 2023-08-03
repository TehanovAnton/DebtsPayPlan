# frozen_string_literal: true

FactoryBot.define do
  factory :group_member do
  end

  factory :group_debts_pay_plan_member do
    group_memberable { association(:group_debts_pay_plan, group_debts_pay_plan_member: instance, group:) }
  end
end
