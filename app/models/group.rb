# frozen_string_literal: true

module Validations
  module Groups
    module Validation
      extend ActiveSupport::Concern

      included do
        validates :group_owner_member, presence: true
      end
    end
  end
end

class Group < ApplicationRecord
  include Validations::Groups::Validation

  is_impressionable

  has_many :group_members, dependent: :destroy
  has_many :users,
           through: :group_members,
           source: :group_memberable,
           source_type: 'User'

  has_one :group_cost_member,
          dependent: :destroy
  has_one :cost,
          through: :group_cost_member,
          source: :group_memberable,
          source_type: 'Cost'

  has_one :group_debts_pay_plan_member,
          dependent: :destroy
  has_one :group_debts_pay_plan,
          through: :group_debts_pay_plan_member,
          source: :group_memberable,
          source_type: 'GroupDebtsPayPlan',
          dependent: :destroy

  has_many :debts,
           through: :group_members,
           source: :group_memberable,
           source_type: 'Debt',
           dependent: :destroy

  has_one :group_owner_member, dependent: :destroy
  has_one :owner,
          through: :group_owner_member,
          source: :group_memberable,
          source_type: 'User'

  has_many :user_step_states,
           through: :group_members,
           source: :group_memberable,
           source_type: 'GroupUserStepState',
           dependent: :destroy

  accepts_nested_attributes_for :group_owner_member

  def average_group_users_cost_value
    return 0 if group_users_costs_values.empty?

    group_users_costs_values.sum / users.length.to_f
  end

  def group_users_costs_values
    Cost.group_users_costs(self)
        .pluck(:cost_value)
  end
end
