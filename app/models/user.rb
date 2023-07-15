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
  has_many :debts

  def group_user_costs(group)
    costs.joins(:group)
         .where(
           costs: { costable_type: self.class.name, costable_id: id },
           groups: { id: group.id }
         )
  end

  def group_user_costs_sum(group)
  end

  def group_user_debt(group)
    group_user_costs(group)&.debt
  end
end
