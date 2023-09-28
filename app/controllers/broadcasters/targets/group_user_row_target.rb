# frozen_string_literal: true

module Broadcasters
  module Targets
    class GroupUserRowTarget
      include TargetMethod

      def initialize(group, user)
        @group = group
        @user = user
      end

      def target
        "row-group-#{@group.id}-user-#{@user.id}"
      end
    end
  end
end
