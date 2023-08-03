# frozen_string_literal: true

module Services
  module Costs
    class CostsCreateDirectorBase
      include Dry::Events::Publisher[:cost_create_deirector_publisher]

      attr_reader :group, :user, :cost_value

      def initialize(group, user, cost_value)
        @group = group
        @user = user
        @cost_value = cost_value
      end

      def create
        subscribe_group_cost_updater
        subscribe_group_users_debt_updater
      end

      private

      def cost
        return @cost if @cost
      end

      def publish_costs_created
        publish('costs.created')
      end

      def subscribe_group_cost_updater
        subscribe 'costs.created' do
          group_cost_updater.update
        end
      end

      def subscribe_group_users_debt_updater
        subscribe 'costs.created' do
          group_users_debt_updater.update
        end
      end
    end
  end
end
