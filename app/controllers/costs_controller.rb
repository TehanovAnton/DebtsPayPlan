# frozen_string_literal: true

class CostsController < ApplicationController
  before_action :authenticate_user!

  add_flash_types :error

  # TODO: make controller own helpers
  helper [Groups::GroupHelpers]

  def new
    @cost = Cost.new
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.includes(:users).find(params[:group_id])
    @cost_value = cost_params(:create)[:cost_value]

    return create_cost_failure_redirect if create_monad.failure?

    respond_to do |format|
      # TODO: try to respond turbo from show
      format.turbo_stream do
        render(turbo_stream: turbo_stream.replace('group-table', partial: '/shared/groups/group_table', locals: { group: @group, cur_user: current_user }))
      end

      format.html { redirect_to @group }
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @cost = Cost.find(params[:id])
  end

  def update
    @group = Group.find(params[:group_id])
    @cost = Cost.find(params[:id])

    return update_cost_failure_redirect if update_cost_monad.failure?

    redirect_to group_path(@group, user_id: current_user.id)
  end

  def destroy
    @group = Group.find(params[:group_id])
    @cost = Cost.find(params[:id])

    return destroy_cost_failure_redirect if destroy_cost_monad.failure?

    redirect_to group_path(@group, user_id: current_user.id)
  end

  private

  # move to cost create director
  def broadcast_to_group_cost_channel
    ActionCable.server.broadcast(group_costs_channel_room, 
      { group_user_row_costs_sum_value:, group_cost_row_value_element: })
  end

  def group_costs_channel_room
    "group_costs_Group #{@group.id} User #{current_user.id}"
  end

  def group_user_row_costs_sum_value
    GroupsController.render(
      partial: '/shared/groups/group_user_row_costs_sum_value_element',
      locals: { user: current_user, group: @group }
    ).squish
  end

  def group_cost_row_value_element
    GroupsController.render(
      partial: '/shared/groups/group_cost_row_value_element',
      locals: { group: @group }
    ).squish
  end

  def create_cost_failure_redirect
    errors = create_monad.failure
    redirect_to(
      user_group_costs_path(current_user, @group),
      error: errors.full_messages.first
    )
  end

  def update_cost_failure_redirect
    errors = update_cost_monad.failure
    redirect_to(
      edit_user_group_cost_path(current_user, @group, @cost),
      error: errors.full_messages.first
    )
  end

  def destroy_cost_failure_redirect
    error = destroy_cost_monad.failure
    redirect_to(
      edit_user_group_cost_path(current_user, @group, @cost),
      error:
    )
  end

  def create_monad
    @create_monad ||= Services::Costs::CostCreateDirector.new(
      @group,
      current_user,
      @cost_value
    ).create
  end

  def update_cost_monad
    @update_cost_monad ||= Services::Costs::CostsUpdateDirector.new(
      @cost,
      @group,
      current_user,
      cost_params(:update)
    ).update
  end

  def destroy_cost_monad
    @destroy_cost_monad ||= Services::Costs::CostDestroyDirector.new(
      @cost,
      @group
    ).destroy
  end

  def cost_params(action)
    case action
    when :create
      params.require(:cost)
            .permit(
              :costable_type,
              :costable_id,
              :cost_value,
              group_member_attributes: [:group_id]
            )
    when :update
      params.require(:cost)
            .permit(
              :cost_value
            )
    end
  end
end
