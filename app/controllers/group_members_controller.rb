class GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_group_member, only: [:destroy]

  def destroy
    group_memberable = @group_member.group_memberable
    @group_member.destroy

    group_user_info = Services::Info::GroupUserCosts.new(@group, group_memberable)
    group_user_info.info.each do |cost|
      Services::Costs::CostDestroyDirector.new(cost, @group).destroy
    end

    redirect_to @group
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_member
    @group_member = GroupMember.find(params[:id])
  end
end
