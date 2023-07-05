# frozen_string_literal: true

class FirstCostCreater
  attr_reader :cost_params

  def initialize(cost_params)
    @cost_params = cost_params
  end

  def create
    @cost = Cost.create(cost_params)
    @group = @cost.group
    group_users_costs_values = Cost.group_users_costs(@group)
                                   .pluck(:cost_value)
    average_group_cost = group_users_costs_values.sum / group_users_costs_values.length.to_f
    @group.cost = GroupCost.create(
      cost_value: average_group_cost,
      group_member_attributes: { group_id: @group.id }
    )
  end
end

class CostCreater
  attr_reader :cost_params

  def initialize(cost_params)
    @cost_params = cost_params
  end

  def create
    @cost = Cost.create(cost_params)
    @group = @cost.group
    group_users_costs_values = Cost.group_users_costs(@group)
                                   .pluck(:cost_value)
    average_group_cost = group_users_costs_values.sum / group_users_costs_values.length.to_f
    @group.cost.update(cost_value: average_group_cost)
  end
end

class CostsController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    cost_creater = if @group.cost
                     CostCreater
                   else
                     FirstCostCreater
                   end

    cost_creater.new(cost_params).create
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
