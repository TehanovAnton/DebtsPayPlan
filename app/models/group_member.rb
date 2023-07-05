# frozen_string_literal: true

class GroupMember < ApplicationRecord
  belongs_to :group_memberable,
             polymorphic: true,
             optional: true
  belongs_to :group
end
