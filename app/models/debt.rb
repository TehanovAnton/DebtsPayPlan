# frozen_string_literal: true

class Debt < ApplicationRecord
  has_many :costs
  has_one :user,
          through: :cost,
          source: :costable,
          source_type: 'User'
  has_one :group_member,
          as: :group_memberablem,
          dependent: :destroy
  has_one :group,
          through: :group_member
end
