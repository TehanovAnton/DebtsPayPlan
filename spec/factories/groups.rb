# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) do |n|
      "Group #{n}"
    end

    trait :with_cost do
      cost factory: :cost
    end

    trait :with_users do
      transient do
        users_count { 2 }
      end
    end

    factory(:group_with_cost, traits: [:with_cost])
  end
end
