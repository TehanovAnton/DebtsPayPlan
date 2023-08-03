# frozen_string_literal: true

FactoryBot.define do
  factory :group_debts_pay_plan do
    group { association(:group) }
  end
end
