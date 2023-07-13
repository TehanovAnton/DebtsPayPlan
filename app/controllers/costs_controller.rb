# frozen_string_literal: true

class CostsController < ApplicationController
  def create
    @group = Group.includes(:users).find(params[:group_id])
    cost_creater = Creaters::CostsCreaters::CostCreater.new(cost_params)
    cost_creater.create

    Updaters::CostsUpdaters::GroupCostUpdater.new(@group, @group.cost).update

    debt_value = cost_creater.cost.cost_value - @group.cost.cost_value
    Debt.create(user: cost_creater.cost.costable, cost: cost_creater.cost, debt_value:)

    group_users_debts_updater = Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(
      @group
    )
    group_users_debts_updater.update
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
