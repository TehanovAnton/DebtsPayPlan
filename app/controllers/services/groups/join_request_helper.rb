# frozen_string_literal: true

module Services
  module Groups
    class JoinRequestHelper < JoinHelperBase
      def send?
        @group.users.include?(@user) ? false : true
      end

      def send
        notification.deliver(@group)
      end

      def error_message
        'You are already in group.'
      end

      private

      def notification
        @notification ||= GroupJoinRequestNotification.with(user: @user)
      end
    end
  end
end
