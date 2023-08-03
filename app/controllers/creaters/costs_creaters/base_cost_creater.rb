# frozen_string_literal: true

module Creaters
  module CostsCreaters
    class BaseCostCreater
      def create
        cost
      end

      def init_group_user_step_state
        @group_user_step_state = costable.group_user_step_state(group) || group_user_step_state_creater.create
      end
    end
  end
end
