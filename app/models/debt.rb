# frozen_string_literal: true

class Debt < ApplicationRecord
  has_many :costs,
           dependent: :destroy
  belongs_to :user

  has_one :group_member,
          as: :group_memberable,
          dependent: :destroy
  has_one :group,
          through: :group_member

  accepts_nested_attributes_for :group_member
end
