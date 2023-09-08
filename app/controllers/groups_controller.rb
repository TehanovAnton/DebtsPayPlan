# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[edit update]

  helper [Groups::GroupHelpers, DebtSteps::DebtStepHelpers]

  def index
    @user_groups = Group.joins(:users).where(
      group_members: {
        type: %w[GroupOwnerMember GroupMember],
        group_memberable_type: 'User',
        group_memberable_id: current_user.id
      }
    )
  end

  def new
  end

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
    cookies[:current_user_id] = current_user.id

    respond_to do |format|
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

      format.html { render 'show' }
    end
  end

  def add_user_member_show
    @group = Group.find(params[:id])
  end

  def add_user_member
    @group = Group.find(params[:id])
    @user = User.find_by(name: params[:user_name])
    @user ||= User.create(name: params[:user_name])

    group_user_adder = Services::Groups::GroupUserAddDirector.new(
      @group,
      @user
    )
    group_user_adder.add

    redirect_to group_path(@group)
  end

  def edit; end

  def update
    @group.update(group_params)

    respond_to do |format|
      format.html { redirect_to @group }
    end
  end

  private

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
