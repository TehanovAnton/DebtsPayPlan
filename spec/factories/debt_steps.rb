# frozen_string_literal: true

FactoryBot.define do
  factory :debt_step do
    debter {}
    recipient {}
    pay_value {}

    transient do
      group {}
    end

    group_debts_pay_plan do
      association(:group_debts_pay_plan, group:)
    end

    after(:create) do |debt_step|
      debt_step.group.group_debts_pay_plan = debt_step.group_debts_pay_plan
      Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(debt_step.group).update
    end
  end
end
