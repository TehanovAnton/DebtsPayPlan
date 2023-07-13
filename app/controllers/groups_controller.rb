# frozen_string_literal: true

class GroupsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
  end

  def create
    @group = Group.create(group_params)
    Creaters::CostsCreaters::GroupCostCreater.new(@group).create

    redirect_to add_user_member_show_group_path(@group)
  end

  def show
    @group = Group.find(params[:id])
  end

  def add_user_member_show
    @group = Group.find(params[:id])
  end

  def add_user_member
    @group = Group.find(params[:id])
    @user = User.find_by(name: params[:user_name])
    @user ||= User.create(name: params[:user_name])
    group_member_adder = Creaters::GroupMembersCreaters::GroupMemberAdder.new(@user, @group)
    group_member_adder.add

    cost_creater = Creaters::CostsCreaters::CostCreater.new({
                                                              costable: @user,
                                                              cost_value: 0,
                                                              group_member_attributes: {
                                                                group: @group
                                                              }
                                                            })
    cost_creater.create

    Debt.create(user: @user, cost: cost_creater.cost, debt_value: 0)

    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group)
          .permit(
            :name,
            group_owner_member_attributes: %i[group_id group_memberable_type group_memberable_id
                                              type]
          )
  end
end
