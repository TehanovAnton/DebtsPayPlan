# frozen_string_literal: true

module Updaters
  module CostsUpdaters
    class GroupCostUpdater
      attr_reader :group, :group_cost

      def initialize(group, group_cost)
        @group = group
        @group_cost = group_cost
      end

      def update
        group_cost.update(cost_value: group.average_group_users_cost_value)
      end
    end
  end
end
