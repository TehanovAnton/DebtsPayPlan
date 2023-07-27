module Creaters
  module DebtSteps
    class DebtStepCreater
      attr_reader :group_debts_pay_plan, :debter, :recipient, :debt_step, :pay_value
    
      def initialize(group_debts_pay_plan, debter, recipient, pay_value)
        @group_debts_pay_plan = group_debts_pay_plan
        @debter = debter
        @recipient = recipient
        @pay_value = pay_value
      end
    
      def create
        @debt_step = DebtStep.create(group_debts_pay_plan:, recipient:, debter:, pay_value:)
      end
    end
  end
end