module Creaters
  module GroupDebtsPayPlans
    class GroupDebtsPayPlanCreater
      attr_reader :group
    
      def initialize(group)
        @group = group
      end
    
      def create
        return @group_debts_pay_plan = @group.group_debts_pay_plan unless group_debts_pay_plan?
    
        @group_debts_pay_plan = GroupDebtsPayPlan.create(group: @group)
      end
    
      private
    
      def group_debts_pay_plan?
        @group.group_debts_pay_plan.nil?
      end
    end
  end
end
