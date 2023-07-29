# frozen_string_literal: true

class CostsController < ApplicationController
  def new
    @cost = Cost.new
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.includes(:users).find(params[:group_id])
    @user = User.find(params[:user_id])
    @cost_value = cost_params[:cost_value]

    Services::Costs::CostCreateDirector.new(
      @group,
      @user,
      @cost_value
    ).create

    redirect_to group_path(@group)
  end

  private

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
