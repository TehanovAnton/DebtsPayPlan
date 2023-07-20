# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) do |n|
      "Group #{n}"
    end

    owner { association(:user) }

    trait :with_cost do
      cost factory: :cost
    end

    trait :with_group_cost do
      transient do
        cost_value { 0 }
      end

      cost { association(:cost, cost_value:) }
    end

    trait :with_group_debt_pay_plan do
      group_debts_pay_plan { association(:group_debts_pay_plan) }
    end
  end
end
