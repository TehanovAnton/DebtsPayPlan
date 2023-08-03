# frozen_string_literal: true

module Services
  module Costs
    class CostCreateDirector < CostsCreateDirectorBase
      register_event('costs.created')

      def create
        super
        cost
      end

      private

      def debt
        @debt ||= Debt.create(user: @user, group: @group, debt_value: 0)
      end

      def cost
        super

        @cost = cost_creater.create
        publish_costs_created
        @cost
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
