module GroupMembers
  module GroupMemberHelpers
    def group_member(group, user)
      Services::Info::GroupUserGroupMember.new(group, user).info
    end
  end
end