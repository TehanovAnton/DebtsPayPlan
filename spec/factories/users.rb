# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) do |n|
      "User #{n}"
    end

    trait :in_group do
      transient do
        group {}
      end

      after(:create) do |user, evaluater|
        GroupMember.create(
          group: evaluater.group,
          group_memberable: user
        )
      end
    end

    trait :with_cost do
      transient do
        cost_value { 0 }
        cost_group {}
      end

      costs { [association(:cost, group: cost_group, cost_value:)] }
    end

    trait :with_debt do
      transient do
        debt_group {}
        debt_value {}
      end

      after(:create) do |user, evaluater|
        Debt.create(
          user:,
          cost: user.group_user_cost(evaluater.debt_group),
          debt_value: evaluater.debt_value
        )
      end
    end
  end
end
