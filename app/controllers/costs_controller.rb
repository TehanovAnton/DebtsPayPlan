# frozen_string_literal: true

class CostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[render_partial]

  add_flash_types :error

  helper [Groups::GroupHelpers]

  def new
    # Open-Closed -> polymorfism
    #   define separate ways for definition cost and group

    # Choose the way of cost and group setting by extending Definers and Setters class

    cost_definer = Services::Costs::Definers::NewCostDefiner.new
    @cost = Services::Costs::Setters::CostSetter.new(cost_definer).set

    group_definer = Services::Costs::Definers::NewGroupDefiner.new(params[:group_id])
    @group = Services::Costs::Setters::GroupSetter.new(group_definer).set
  end

  def create
    # Open close -> polymorfism

    group_definer = Services::Costs::Definers::CreateGroupDefiner.new(params[:group_id])
    @group = Services::Costs::Setters::GroupSetter.new(group_definer).set

    controller_params = Services::Costs::ControllerParams::CreateControllerParams.new(params)

    director = Services::Costs::CostCreateDirector.new(
      @group,
      current_user,
      controller_params.params[:cost_value]
    )
    create_monad = Services::Costs::Monads::CreateCostMonad.new(director).monad

    return create_cost_failure_redirect(create_monad) if create_monad.failure?

    redirect_to @group
  end

  def edit
    # Provide multiple ways to fine group or cost, for example by association
    @group = Services::Costs::Definers::GroupByIdDefiner.new(params[:group_id]).define
    @cost = Services::Costs::Definers::CostByIdDefiner.new(params[:id]).define
  end

  def update
    @group = Group.find(params[:group_id])
    @cost = Cost.find(params[:id])

    return update_cost_failure_redirect if update_cost_monad.failure?

    flash.clear
    redirect_to group_path(@group, user_id: current_user.id)
  end

  def destroy
    @group = Group.find(params[:group_id])
    @cost = Cost.find(params[:id])
    @user_costs_table_row_id = helpers.user_costs_table_row_id(current_user, @cost)

    return destroy_cost_failure_redirect if destroy_cost_monad.failure?

    respond_to do |format|
      format.turbo_stream do
        render(turbo_stream: [
                 turbo_stream.remove(@user_costs_table_row_id),
                 turbo_stream.replace('group-table',
                                      partial: '/shared/groups/group_table',
                                      locals: { group: @group, cur_user: current_user })
               ])
      end

      format.html { redirect_to group_path(@group, user_id: current_user.id) }
    end
  end

  def render_partial
    @partial_path = params[:path]
    turbo_frame = params[:turbo_frame]

    respond_to do |format|
      format.html do
        render(partial: @partial_path, locals: { cur_user: current_user, group: @group, turbo_frame: })
      end
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def create_cost_failure_redirect(create_monad)
    errors = create_monad.failure
    flash.now[:error] = errors.full_messages.first

    respond_to do |format|
      format.html do
        redirect_to(new_user_group_cost_path(current_user, @group))
      end

      format.turbo_stream do
        render(turbo_stream: turbo_stream.replace('flash_errors', partial: '/shared/groups/flash_errors'))
      end
    end
  end

  def update_cost_failure_redirect
    errors = update_cost_monad.failure
    flash.now[:error] = errors.full_messages.first

    respond_to do |format|
      format.turbo_stream do
        render(turbo_stream: [
                 turbo_stream.replace('flash_errors',
                                      partial: '/shared/groups/flash_errors'),
                 turbo_stream.replace('user_costs',
                                      partial: '/shared/costs/edit_form',
                                      locals: { cur_user: current_user, group: @group, cost: @cost })
               ])
      end

      format.html do
        redirect_to(edit_user_group_cost_path(current_user, @group, @cost))
      end
    end
  end

  def destroy_cost_failure_redirect
    error = destroy_cost_monad.failure
    redirect_to(
      edit_user_group_cost_path(current_user, @group, @cost),
      error:
    )
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
