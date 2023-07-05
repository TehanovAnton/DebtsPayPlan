# frozen_string_literal: true

class Cost < ApplicationRecord
  has_one :debt, dependent: :destroy

  has_one :group_member,
          as: :group_memberable,
          dependent: :destroy
  has_one :group, through: :group_member

  belongs_to :costable,
             polymorphic: true,
             optional: true

  scope :group_cost, lambda { |group|
                       Cost.joins(:group)
                           .where(
                             costs: { costable_type: 'User', costable_id: id },
                             groups: { id: group.id }
                           ).first
                     }
  scope :group_users_costs, lambda { |group|
    Cost.joins(:group_member)
        .where(
          group_members: { group_id: group.id },
          costs: { costable_type: 'User' }
        )
  }

  accepts_nested_attributes_for :group_member
end
