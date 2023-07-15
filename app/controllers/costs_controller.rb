# frozen_string_literal: true

class CostsController < ApplicationController
  def new
    @cost = Cost.new
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.includes(:users).find(params[:group_id])
    cost_creater = Creaters::CostsCreaters::CostCreater.new(cost_params)
    cost_creater.create

    Updaters::CostsUpdaters::GroupCostUpdater.new(@group, @group.cost).update

    debt_value = cost_creater.cost.cost_value - @group.cost.cost_value
    Debt.create(user: cost_creater.cost.costable, cost: cost_creater.cost, debt_value:)

    Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(@group).update

    redirect_to group_path(@group)
  end

  def edit
    user
    group
    cost
  end

  def update
    cost.update(cost_params)

    Updaters::CostsUpdaters::GroupCostUpdater.new(group, group.cost).update
    Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(group).update

    redirect_to group_path(group)
  end

  private

  def group
    @group ||= Group.find(params[:group_id])
  end

  def cost
    @cost ||= Cost.find(params[:id])
  end

  def user
    @user ||= User.find(params[:user_id])
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
