# frozen_string_literal: true

class CostsController < ApplicationController
  before_action :authenticate_user!

  add_flash_types :error

  def new
    @cost = Cost.new
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.includes(:users).find(params[:group_id])
    @user = User.find(params[:user_id])
    @cost_value = cost_params[:cost_value]

    return create_cost_failure_redirect if create_monad.failure?

    redirect_to group_path(@group, user_id: @user.id)
  end

  private

  def create_cost_failure_redirect
    errors = create_monad.failure
    redirect_to(
      user_group_costs_path(@user, @group),
      error: errors.full_messages.first
    )
  end

  def create_monad
    @create_monad ||= Services::Costs::CostCreateDirector.new(
      @group,
      @user,
      @cost_value
    ).create
  end

  def cost_params
    params.require(:cost)
          .permit(
            :costable_type,
            :costable_id,
            :cost_value,
            group_member_attributes: [:group_id]
          )
  end
end
