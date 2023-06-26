# frozen_string_literal: true

module Validations
  module Groups
    module Validation
      extend ActiveSupport::Concern

      included do
        validates :cost, presence: true
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
  has_one :cost,
          as: :costable,
          dependent: :destroy

  accepts_nested_attributes_for :cost
end
