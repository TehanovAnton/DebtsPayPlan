# frozen_string_literal: true

class CostsController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    cost_creater = Creaters::CostsCreaters::CostCreater.new(cost_params)
    cost_creater.create

    if @group.cost
      Updaters::CostsUpdaters::GroupCostUpdater.new(@group, @group.cost).update
    else
      Creaters::CostsCreaters::GroupCostCreater.new(@group).create
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
