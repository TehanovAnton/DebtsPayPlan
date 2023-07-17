# frozen_string_literal: true

module Creaters
  module CostsCreaters
    class GroupCostCreater < BaseCostCreater
      attr_reader :group

      def initialize(group)
        super()

        @group = group
      end

      def create
        GroupCost.create(
          cost_value: group.average_group_users_cost_value,
          costable: group,
          group:
        )
      end
    end
  end
end
