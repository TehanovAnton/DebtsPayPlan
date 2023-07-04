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
          source_type: 'Cost',
          dependent: :destroy
end
