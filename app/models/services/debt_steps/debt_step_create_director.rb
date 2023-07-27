module Services
  module DebtSteps
    class DebtStepCreateDirector
      attr_reader :group, :debter, :recipient, :pay_value, :debt_step

      def initialize(group, debter, recipient, pay_value)
        @group = group
        @debter = debter
        @recipient = recipient
        @pay_value = pay_value
      end

      def create
        group_debts_pay_plan_creater.create
        @debt_step = debt_step_creater.create
      end

      private

      def group_debts_pay_plan_creater
        @group_debts_pay_plan_creater ||= Creaters::GroupDebtsPayPlans::GroupDebtsPayPlanCreater.new(group)
      end

      def debt_step_creater
        @debt_step_creater ||= Creaters::DebtSteps::DebtStepCreater.new(
          group_debts_pay_plan_creater.group_debts_pay_plan,
          debter,
          recipient,
          pay_value
        )
      end
    end
  end
end