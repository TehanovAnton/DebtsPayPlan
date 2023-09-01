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
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    group_create_director = Services::Groups::GroupCreateDirector.new(
      group_params[:name],
      @user
    )
    group_create_director.create

    redirect_to add_user_member_show_group_path(group_create_director.group)
  end

  def show
    @group = Group.find(params[:id])
    @cost = Cost.new
    cookies[:current_user_id] = current_user.id
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

  def edit
  end

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
