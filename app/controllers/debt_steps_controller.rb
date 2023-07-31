# frozen_string_literal: true

class DebtStepsController < ApplicationController
  add_flash_types :error

  def new
    @group = Group.find(params[:group_id])

    begin
      @debt_step = DebtStep.new(**debt_step_form_fields_params)
    rescue ActionController::ParameterMissing
      @debt_step = DebtStep.new
    end
  end

  def create
    @group = Group.find(params[:group_id])
    @debter = User.find(debt_step_params[:debter_id])
    @recipient = User.find(debt_step_params[:recipient_id])
    @pay_value = debt_step_params[:pay_value].to_f

    debt_step_create_director = Services::DebtSteps::DebtStepCreateDirector.new(
      @group,
      @debter,
      @recipient,
      @pay_value
    )
    debt_step_create_director.create
    @debt_step = debt_step_create_director.debt_step

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
    params.require(:debt_step).permit(:debter_id, :recipient_id, :pay_value)
  end

  def debt_step_form_fields_names
    %i[debter_id recipient_id group_debts_pay_plan_id pay_value]
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
