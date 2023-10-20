module Services
  module Info
    class GroupUserGroupMember < GroupUserInfo
      def info
        @group.group_members.find_by(group_memberable: @user)
      end
    end
  end
end