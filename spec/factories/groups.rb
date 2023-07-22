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

      cost { association(:group_cost, cost_value:) }
    end

    trait :with_group_debt_pay_plan do
      group_debts_pay_plan { association(:group_debts_pay_plan) }
    end

    transient do
      add_users {}
    end

    after(:create) do |group, evluater|
      return unless evluater.add_users

      group.users << evluater.add_users
    end
  end
end
