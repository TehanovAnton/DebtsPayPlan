# frozen_string_literal: true

FactoryBot.define do
  factory :cost do
    cost_value { 0 }
    association :group
  end
end
