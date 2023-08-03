# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) do |n|
      "User #{n}"
    end

    sequence(:email) do |n|
      "user_#{n}@gmail.com"
    end

    password { 'ewqqwe' }

    password_confirmation { 'ewqqwe' }

    transient do
      in_group {}

      after(:create) do |user, evaluater|
        group = evaluater.in_group
        group.users << user if group
      end
    end

    trait :with_cost do
      transient do
        cost_value { 0 }
        cost_group {}
      end

      costs { [association(:cost, group: cost_group, cost_value:)] }
    end
  end
end
