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

    debt_params = {
      user: @user,
      debt_value: 0,
      group: @group
    }
    @debt = Debt.create(debt_params)

    cost_creater_params = {
      debt_id: @debt.id,
      costable: @user,
      cost_value: 0,
      group_member_attributes: {
        group: @group
      }
    }
    cost_creater = Creaters::CostsCreaters::CostCreater.new(**cost_creater_params)
    cost_creater.create

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
