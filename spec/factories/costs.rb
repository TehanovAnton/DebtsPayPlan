# frozen_string_literal: true

FactoryBot.define do
  factory :cost do
    group {}
    costable {}
    cost_value { 0 }
    debt { association(:debt, group:, user: costable) }

    after :create do |_, evaluater|
      Updaters::CostsUpdaters::GroupCostUpdater.new(
        evaluater.group,
        evaluater.group.cost
      ).update

      Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(evaluater.group)
                                                     .update
    end
  end

  factory :group_cost do
  end
end
