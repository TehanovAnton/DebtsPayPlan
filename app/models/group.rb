# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :users,
           through: :group_members,
           source: :group_memberable,
           source_type: 'User'
end
