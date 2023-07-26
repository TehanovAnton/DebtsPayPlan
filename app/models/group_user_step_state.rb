# frozen_string_literal: true

class GroupUserStepState < ApplicationRecord
  belongs_to :user

  has_one :group_member,
          as: :group_memberable,
          dependent: :destroy
  has_one :group,
          through: :group_member

  def change_state(cost)
    update(cost_ids: [cost.id])
    cost_values << cost.cost_value
  end
end
