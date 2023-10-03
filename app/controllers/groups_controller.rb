# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[edit update]

  add_flash_types :error

  helper [Groups::GroupHelpers, DebtSteps::DebtStepHelpers]

  def index
    @user_groups = Group.all
  end

  def new; end

  def create
    group_create_director = Services::Groups::GroupCreateDirector.new(
      group_params[:name],
      current_user
    )
    group_create_director.create

    redirect_to groups_path(group_create_director.group)
  end

  def show
    @group = Group.find(params[:id])
    @cost = Cost.new

    impressionist(@group)

    broadcast_builder = Builders::GroupUserRowBroadcasterBuilder.new(@group, current_user)
    Builders::Directors::GroupUserRowBroadcastDirector.new(
      broadcast_builder
    ).build
    broadcast_builder.result
                     .broadcast

    respond_to do |format|
      unless params[:html_only]
        format.turbo_stream do
          render(turbo_stream: [
                   turbo_stream.replace('group-table',
                                        partial: '/shared/groups/group_table',
                                        locals: { group: @group, cur_user: current_user, turbo_frame: 'user_costs' }),
                   turbo_stream.replace('user_costs',
                                        partial: '/shared/groups/group_user_costs',
                                        locals: { cur_user: current_user, group: @group, turbo_frame: 'user_costs' }),
                   turbo_stream.replace('user_group_debt_steps',
                                        partial: '/shared/groups/group_user_debt_steps'),
                   turbo_stream.replace('flash_errors',
                                        partial: '/shared/groups/flash_errors')
                 ])
        end
      end

      format.html { render 'show' }
    end
  end

  def add_user_member_show
    @group = Group.find(params[:id])
  end

  def join_request_notification
    @group = Group.find(params[:id])
    join_request_helper = Services::Groups::JoinRequestHelper.new(@group, current_user)
    join_request_helper.send if join_request_helper.send?
  end

  def join_requests
    # TODO: preload notifications
    @group = Group.find(params[:id])
    @notifications = @group.notifications
  end

  def add_user_member
    @group = Group.find(params[:id])
    @user = User.find(params[:user_id])
    Notification.find(params[:notification_id]).destroy

    add_user_member_failure_redirect if add_user_member_monad.failure?

    redirect_to group_path(@group, html_only: true)
  end

  def edit; end

  def update
    @group.update(group_params)

    respond_to do |format|
      format.html { redirect_to @group }
    end
  end

  private

  def add_user_member_failure_redirect
    error = add_user_member_monad.failure
    flash[:error] = error
  end

  def add_user_member_monad
    @add_user_member_monad ||= Services::Groups::GroupUserAddDirector.new(
      @group,
      @user
    ).add
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group)
          .permit(
            :name,
            group_owner_member_attributes: %i[group_id group_memberable_type group_memberable_id
                                              type]
          )
  end
end
