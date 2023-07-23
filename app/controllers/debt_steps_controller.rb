# frozen_string_literal: true

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
  add_flash_types :error

  def new
    @group = Group.find(params[:group_id])
    @debt_step = DebtStep.new(**debt_step_form_fields_params)
  end

  def create
    @group = Group.find(params[:group_id])
    @debter = User.find(debt_step_params[:debter_id])
    @recipient = User.find(debt_step_params[:recipient_id])

    @group_debts_pay_plan = GroupDebtsPayPlanCreater.new(@group).create
    @debt_step = DebtStepCreater.new(@group_debts_pay_plan, @debter, @recipient).create

    return redirect_to group_path(@group) if @debt_step.valid?

    flash_errors
    redirect_to new_group_debt_step_path(@group, debt_step_form_fields:)
  end

  private

  def flash_errors
    @debt_step.errors.each do |error|
      flash[:error] = error.full_message
    end
  end

  def debt_step_params
    params.require(:debt_step).permit(:debter_id, :recipient_id)
  end

  def debt_step_form_fields_names
    %i[debter_id recipient_id group_debts_pay_plan_id]
  end

  def debt_step_form_fields_params
    params.require(:debt_step_form_fields)
          .permit(*debt_step_form_fields_names)
  end

  def debt_step_form_fields
    fields = debt_step_form_fields_names

    @debt_step.attributes.select do |key, _|
      fields.include?(key.to_sym)
    end
  end
end
