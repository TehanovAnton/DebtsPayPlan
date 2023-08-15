# frozen_string_literal: true

module Services
  module Costs
    class BaseDirector
      private

      def subscribe_group_cost_updater
        subscribe deirector_event do
          group_cost_updater.update
        end
      end

      def subscribe_group_users_debt_updater
        subscribe deirector_event do
          group_users_debt_updater.update
        end
      end

      def publish_director_event
        publish(deirector_event)
      end

      def deirector_event
        self.class::DIRECTOR_EVENT
      end

      def group_cost_updater
        @group_cost_updater ||= Updaters::CostsUpdaters::GroupCostUpdater.new(group, group.cost)
      end

      def group_users_debt_updater
        @group_users_debt_updater ||= Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(group)
      end
    end
  end
end
