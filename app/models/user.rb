# frozen_string_literal: true

class User < ApplicationRecord
  has_many :group_members,
           as: :group_memberable,
           dependent: :destroy
  has_many :groups,
           through: :group_members
  has_many :costs,
           as: :costable,
           dependent: :destroy

  def group_user_cost(group)
    costs.joins(:group)
         .where(
           costs: { costable_type: self.class.name, costable_id: id },
           groups: { id: group.id }
         ).first
  end

  def group_user_debt(group)
    group_user_cost(group)&.debt
  end
end
