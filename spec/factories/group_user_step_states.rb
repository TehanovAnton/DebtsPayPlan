# frozen_string_literal: true

FactoryBot.define do
  factory :group_user_step_state do
    user {}
    group {}

    after(:create) do |step_state, evaluater|
      user = evaluater.user
      group = evaluater.group

      user.group_user_costs(group).each do |cost|
        step_state.change_state(cost)
      end
    end
  end
end
