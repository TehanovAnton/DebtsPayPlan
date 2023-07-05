# frozen_string_literal: true

module Validations
  module Groups
    module Validation
      extend ActiveSupport::Concern

      included do
      end
    end
  end
end

class Group < ApplicationRecord
  include Validations::Groups::Validation

  has_many :group_members, dependent: :destroy
  has_many :users,
           through: :group_members,
           source: :group_memberable,
           source_type: 'User'

  has_one :group_member, dependent: :destroy
  has_one :cost,
          through: :group_member,
          source: :group_memberable,
          source_type: 'GroupCost',
          dependent: :destroy

  def average_group_users_cost_value
    group_users_costs_values.sum / group_users_costs_values.length.to_f
  end

  def group_users_costs_values
    Cost.group_users_costs(self)
        .pluck(:cost_value)
  end
end
