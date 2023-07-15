# frozen_string_literal: true

module Updaters
  module DebtsUpdaters
    class GroupUsersDebtsUpdater
      attr_reader :group

      def initialize(group)
        @group = group
      end

      def update
        group.users.each do |user|
          user_cost = user.group_user_costs(@group)
          debt_value = user_cost.cost_value - @group.cost.cost_value
          debt = user.group_user_debt(@group)
          next debt.update(debt_value:) if debt

          Debt.create(user:, cost: user_cost, debt_value:)
        end
      end
    end
  end
end
