# frozen_string_literal: true

class GroupUserStepState < ApplicationRecord
  has_paper_trail

  belongs_to :user

  has_one :group_member,
          as: :group_memberable,
          dependent: :destroy
  has_one :group,
          through: :group_member

  def change_state(cost)
    update(cost_ids: cost_ids << cost.id)
  end
end
