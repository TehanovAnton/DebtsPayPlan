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
        costs_sum - group_cost_value +
          debt_steps_pay_value_sum(debter_debt_steps) -
          debt_steps_pay_value_sum(recipient_debt_steps)
      end

      private

      def debt_steps_pay_value_sum(debt_steps)
        debt_steps.pluck(:pay_value).sum
      end

      def debter_debt_steps
        DebtStep.joins(:group_debts_pay_plan)
                .where(
                  group_debts_pay_plan: { id: group.group_debts_pay_plan },
                  debt_steps: { debter_id: user.id }
                )
      end

      def recipient_debt_steps
        DebtStep.joins(:group_debts_pay_plan)
                .where(
                  group_debts_pay_plan: { id: group.group_debts_pay_plan },
                  debt_steps: { recipient: user.id }
                )
      end
    end
  end
end
