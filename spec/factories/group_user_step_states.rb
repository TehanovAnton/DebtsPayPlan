# frozen_string_literal: true

FactoryBot.define do
  factory :group_user_step_state do
    user {}
    group {}
  end
end
