module Broadcasters
  class FirstUserGroupImpressionBroadcaster < Broadcaster
    def initialize(broadcastable, user_group_impression_helper)
      super(broadcastable)

      @user_group_impression_helper = user_group_impression_helper
    end

    def broadcast
      super if @user_group_impression_helper.impressioned_now?
    end
  end
end