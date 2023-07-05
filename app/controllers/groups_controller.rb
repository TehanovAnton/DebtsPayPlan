# frozen_string_literal: true

class GroupsController < ApplicationController
  def create
    Group.create(group_params)
  end

  def show
    @group = Group.find(params[:id])
  end

  private

  def group_params
    params.require(:group)
          .permit(:name, group_owner_member_attributes: %i[group_id group_memberable_type group_memberable_id
                                                           type])
  end
end
