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
        group.cost = GroupCost.create(
          cost_value: group.average_group_users_cost_value,
          group_member_attributes: { group_id: group.id }
        )
      end
    end
  end
end
