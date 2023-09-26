module Services
  module Impressions
    class GroupUserImpression
      include ImpressionedMethod

      def initialize(group, user)
        @group = group
        @user = user
      end

      def impressioned?
        Impression.where(impressionable: @group, user_id: @user.id).count >= 1
      end

      def impressioned_now?
        Impression.where(impressionable: @group, user_id: @user.id).count == 1
      end
    end
  end
end