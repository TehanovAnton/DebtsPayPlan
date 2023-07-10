# frozen_string_literal: true

class CostsController < ApplicationController
  def create
    @group = Group.includes(:users).find(params[:group_id])
    cost_creater = Creaters::CostsCreaters::CostCreater.new(cost_params)
    cost_creater.create

    if @group.cost
      Updaters::CostsUpdaters::GroupCostUpdater.new(@group, @group.cost).update
    else
      Creaters::CostsCreaters::GroupCostCreater.new(@group).create
      # Group debts creater
      @group.users.each do |user|
        debt_value = cost_creater.cost.cost_value - @group.cost.cost_value
        Debt.create(user:, cost: cost_creater.cost, debt_value:)
      end
    end
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
