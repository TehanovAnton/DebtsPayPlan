# frozen_string_literal: true

module Creaters
  module GroupUserStepStatesCreaters
    class GroupUserStepStateCreater
      attr_reader :user, :group

      def initialize(user, group)
        @user = user
        @group = group
      end

      def create
        return @group_user_step_state if group_user_step_state

        GroupUserStepState.create(
          group:,
          user:
        )
      end

      delegate :change_state, to: :group_user_step_state

      def group_user_step_state
        @group_user_step_state ||= user.group_user_step_state(group)
      end
    end
  end
end
