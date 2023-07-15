# frozen_string_literal: true

class GroupOwnerMember < GroupMember
  belongs_to :group_memberable,
             polymorphic: true,
             class_name: 'User',
             optional: true
  belongs_to :group
end
