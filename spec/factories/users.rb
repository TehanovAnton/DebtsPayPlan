# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) do |n|
      "User #{n}"
    end
  end
end