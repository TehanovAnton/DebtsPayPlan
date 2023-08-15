# frozen_string_literal: true

module Services
  module Costs
    class CostDestroyDirector < BaseDirector
      include Dry::Events::Publisher[:cost_destroy_deirector_publisher]

      attr_reader :cost, :group

      DIRECTOR_EVENT = 'costs.destroyed'

      register_event(DIRECTOR_EVENT)

      def initialize(cost, group)
        super()

        @cost = cost
        @group = group
      end

      def destroy
        subscribe_group_cost_updater
        subscribe_group_users_debt_updater
        publish_director_event if destroy_cost_monad.success?
        destroy_cost_monad
      end

      private

      def destroy_cost_monad
        @destroy_cost_monad ||= Destroyers::Costs::CostDestroyer.new(@cost).destroy
      end
    end
  end
end
