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

  def update
    @group = Group.find(params[:group_id])
    @debt_step = DebtStep.find(params[:id])

    return redirect_to(group_path(@group)) if update_debt_step_monad.success?

    update_debt_step_failure_redirect
  end

  def destroy
    @group = Group.find(params[:group_id])
    @debt_step = DebtStep.find(params[:id])

    Services::DebtSteps::DebtStepDestroyDirector.new(
      @debt_step,
      group: @group
    ).destroy

    redirect_to group_path(@group)
  end

  private

  def update_debt_step_failure_redirect
    errors = update_debt_step_monad.failure
    redirect_to(
      edit_group_debt_step_path(@group, @debt_step),
      error: errors.full_messages.first
    )
  end

  def update_debt_step_monad
    @update_debt_step_monad = Services::DebtSteps::DebtStepUpdateDirector.new(
      @debt_step,
      @group,
      debt_step_params
    ).udpate
  end

  def flash_errors
    error = @debt_step.errors.full_messages.first
    flash[:error] = error
  end

  def debt_step_params
    params.require(:debt_step).permit(:debter_id, :recipient_id, :pay_value)
  end

  def debt_step_form_fields_names
    Services::DebtSteps::FROM_FIELDS
  end

  def debt_step_form_fields_params
    params.require(:debt_step_form_fields)
          .permit(*debt_step_form_fields_names)
  end

  def debt_step_form_fields
    create_form_fields_saver.form_fields
  end

  def create_form_fields_saver
    @create_form_fields_saver ||= Services::DebtSteps::CreateFormFieldsSaver.new(@debt_step)
  end
end
