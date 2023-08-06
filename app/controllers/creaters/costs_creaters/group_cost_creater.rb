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
        return group.cost if group.cost

        GroupCost.create(
          cost_value: group.average_group_users_cost_value,
          costable: group,
          group_member_attributes: {
            group:,
            type: 'GroupCostMember'
          }
        )
      end
    end
  end
end
