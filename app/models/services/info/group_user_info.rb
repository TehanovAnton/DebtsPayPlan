module Services
  module Info
    class GroupUserInfo
      attr_reader :group, :user

      def initialize(group, user)
        @user = user
        @group = group
      end

      def info
        raise StandardError, 'Not Implemented'
      end
    end
  end
end