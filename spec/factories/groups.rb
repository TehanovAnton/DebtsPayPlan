# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) do |n|
      "Group #{n}"
    end

    trait :with_cost do
      cost { association(:cost) }
    end

    trait :with_users do
      transient do
        users_count { 2 }
      end
    end
  end
end
