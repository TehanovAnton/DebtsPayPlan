# frozen_string_literal: true

module Services
  module Costs
    class CostCreateDirector
      attr_reader :group, :user, :cost_value

      def initialize(group, user, cost_value)
        @group = group
        @user = user
        @cost_value = cost_value
      end

      def create
        cost
        group_cost_updater.update
        group_users_debt_updater.update
      end

      private

      def debt
        @debt ||= Debt.create(user: @user, group: @group, debt_value: 0)
      end

      def cost
        @cost ||= cost_creater.create
      end

      def cost_creater
        @cost_creater ||= Creaters::CostsCreaters::CostCreater.new(
          user,
          cost_value,
          group,
          debt
        )
      end

      def group_cost_updater
        @group_cost_updater ||= Updaters::CostsUpdaters::GroupCostUpdater.new(group, group.cost)
      end

      def group_users_debt_updater
        @group_users_debt_updater ||= Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(group)
      end
    end
  end
end
