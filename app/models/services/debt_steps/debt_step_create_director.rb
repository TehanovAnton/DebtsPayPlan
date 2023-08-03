# frozen_string_literal: true

module Services
  module DebtSteps
    class DebtStepCreateDirector
      attr_reader :group,
                  :debter,
                  :recipient,
                  :pay_value,
                  :debter_debt,
                  :recipient_debt,
                  :debter_step_state,
                  :recipient_step_state

      def initialize(group, debter, recipient, pay_value)
        @group = group
        @debter = debter
        @recipient = recipient
        @pay_value = pay_value
      end

      def create
        group_debts_pay_plan
        debt_step
        update_user_debt(debter)
        update_user_debt(recipient)
      end

      def debt_step
        @debt_step ||= debt_step_creater.create
      end

      private

      def user_step_state(debter)
        case user
        when debter
          @debter_step_state ||= group_user_step_state_creater.new(debter, group).create
        when recipient
          @recipient_step_state ||= group_user_step_state_creater.new(recipient, group).create
        end
      end

      def group_user_step_state_creater
        Creaters::GroupUserStepStatesCreaters::GroupUserStepStateCreater
      end

      def group_debts_pay_plan
        @group_debts_pay_plan ||= group.group_debts_pay_plan || group_debts_pay_plan_creater.create
      end

      def group_debts_pay_plan_creater
        @group_debts_pay_plan_creater ||= Creaters::GroupDebtsPayPlans::GroupDebtsPayPlanCreater.new(group)
      end

      def debt_step_creater
        @debt_step_creater ||= Creaters::DebtSteps::DebtStepCreater.new(
          group_debts_pay_plan,
          debter,
          recipient,
          pay_value
        )
      end

      def user_debt(user)
        case user
        when debter
          @debter_debt ||= user.group_user_debt(group)
        when recipient
          @recipient_debt ||= user.group_user_debt(group)
        end
      end

      def update_user_debt(user)
        user_debt(user).update(
          debt_value: changed_debt(user)
        )
      end

      def changed_debt(user)
        case user
        when debter
          (user_debt(user).debt_value + pay_value).to_f
        when recipient
          (user_debt(user).debt_value - pay_value).to_f
        end
      end
    end
  end
end
