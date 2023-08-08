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
    end
  end
end
