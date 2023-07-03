# frozen_string_literal: true

class Cost < ApplicationRecord
  has_one :debt, dependent: :destroy
  belongs_to :group
  belongs_to :costable,
             polymorphic: true

  scope :group_cost, ->(group) { Cost.joins(:group).where(groups: { id: group.id }).first }
end
