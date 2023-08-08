# frozen_string_literal: true

module Services
  module Costs
    class CostsCreateDirectorBase < BaseDirector
      include Dry::Events::Publisher[:cost_create_deirector_publisher]

      attr_reader :group, :user, :cost_value

      def initialize(group, user, cost_value)
        super()

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
    end
  end
end
