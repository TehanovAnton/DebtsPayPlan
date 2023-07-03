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
end
