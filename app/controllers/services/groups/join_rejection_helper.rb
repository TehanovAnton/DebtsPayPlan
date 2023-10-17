# frozen_string_literal: true

module Services
  module Groups
    class JoinRejectionHelper < JoinHelperBase
      def send?
        @group.user_join_notifications(@user).any?
      end

      def send
        deliver
        destroy_join_requests
      end

      def error_message
        'User has no join requests to group'
      end

      private

      def deliver
        notification.deliver(@user)
      end

      def destroy_join_requests
        @group.notifications.where(params: { user: @user }).delete_all
      end

      def notification
        @notification ||= GroupJoinRejectionNotification.with(group: @group, message: 'Your join request is rejected')
      end
    end
  end
end
