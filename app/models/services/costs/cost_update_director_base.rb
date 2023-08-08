# frozen_string_literal: true

module Services
  module Costs
    class CostUpdateDirectorBase < BaseDirector
      include Dry::Events::Publisher[:cost_update_deirector_publisher]

      attr_reader :cost, :group, :user, :update_params

      def initialize(cost, group, user, update_params)
        super()

        @cost = cost
        @group = group
        @user = user
        @update_params = update_params
      end

      def update
        subscribe_group_cost_updater
        subscribe_group_users_debt_updater
      end

      def group_cost_updater
        Updaters::CostsUpdaters::GroupCostUpdater.new(
          group,
          group.cost
        )
      end

      def group_users_debt_updater
        Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(
          group
        )
      end
    end
  end
end
