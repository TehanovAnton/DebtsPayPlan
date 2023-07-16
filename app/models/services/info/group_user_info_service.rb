# frozen_string_literal: true

module Services
  module Info
    class GroupUserInfoService
      attr_reader :group, :user

      def initialize(user, group)
        @user = user
        @group = group
      end

      def costs
        user.costs.joins(:group)
            .where(
              costs: { costable_type: user.class.name, costable_id: user.id },
              groups: { id: group.id }
            )
      end

      def costs_sum
        costs.pluck(:cost_value).sum
      end

      def debt
        user.debts
            .joins(:group)
            .where(group_members: { group_id: group.id })
            .first
      end

      def group_cost_value
        group.cost.cost_value
      end

      def callculate_debt_value
        costs_sum - group_cost_value
      end
    end
  end
end
