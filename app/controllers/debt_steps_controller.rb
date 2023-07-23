class DebtStepCreater
  attr_reader :group_debts_pay_plan, :debter, :recipient, :debt_step

  def initialize(group_debts_pay_plan, debter, recipient)
    @group_debts_pay_plan = group_debts_pay_plan
    @debter = debter
    @recipient = recipient
  end

  def create
    @debt_step = DebtStep.create(group_debts_pay_plan:, recipient:, debter:)
  end
end

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

class DebtStepsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @debt_step = DebtStep.new
  end

  def create
    @group = Group.find(params[:group_id])
    @debter = User.find(debt_step_params[:debter_id])
    @recipient = User.find(debt_step_params[:recipient_id])

    @group_debts_pay_plan = GroupDebtsPayPlanCreater.new(@group).create
    @debt_step = DebtStepCreater.new(@group_debts_pay_plan, @debter, @recipient).create

    redirect_to group_path(@group)
  end

  private

  def debt_step_params
    params.require(:debt_step).permit(:debter_id, :recipient_id)
  end
end
