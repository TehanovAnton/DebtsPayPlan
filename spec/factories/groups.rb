# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) do |n|
      "Group #{n}"
    end

    owner { association(:user) }

    cost { association(:group_cost) }

    trait :with_group_debt_pay_plan do
      group_debts_pay_plan { association(:group_debts_pay_plan) }
    end

    transient do
      add_users {}
    end

    after(:create) do |group, evluater|
      users = evluater.add_users
      group.users << users if users
    end
  end
end
