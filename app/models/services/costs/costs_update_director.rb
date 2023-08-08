# frozen_string_literal: true

module Services
  module Costs
    class CostsUpdateDirector < CostUpdateDirectorBase
      DIRECTOR_EVENT = 'costs.updated'

      register_event(DIRECTOR_EVENT)

      def update
        super

        publish_director_event if update_cost_monad.success?
        update_cost_monad
      end

      private

      def update_cost_monad
        @update_cost_monad ||= cost_updater.update
      end

      def cost_updater
        @cost_updater ||= Updaters::CostsUpdaters::CostUpdater.new(
          @cost,
          update_params
        )
      end
    end
  end
end
