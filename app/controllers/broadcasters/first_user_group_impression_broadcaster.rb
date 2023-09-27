# frozen_string_literal: true

module Broadcasters
  class FirstUserGroupImpressionBroadcaster < Broadcaster
    def initialize(target, partial_loader, group, user)
      @target = target
      @partial_loader = partial_loader
      @group = group
      @user = user

      super(
        Services::Broadcasters::Groups::GroupBroadcaster.new(
          @group,
          @target,
          @partial_loader.load
        )
      )
    end

    def broadcast
      super if user_group_impression_helper.impressioned_now?
    end

    private

    def user_group_impression_helper
      Services::Impressions::GroupUserImpression.new(@group, @user)
    end
  end
end
