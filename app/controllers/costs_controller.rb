# frozen_string_literal: true

class CostsController < ApplicationController
  def create
    @cost = Cost.create(cost_params)
    @group = @cost.group
    group_users_costs_values = Cost.group_users_costs(@group)
                                   .pluck(:cost_value)
    average_group_cost = group_users_costs_values.sum / group_users_costs_values.length.to_f
    Cost.create(
      cost_value: average_group_cost,
      group_member_attributes: { group_id: @group.id }
    )
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
