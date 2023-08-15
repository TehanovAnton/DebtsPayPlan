# frozen_string_literal: true

module Services
  module Costs
    class CostCreateDirector < CostsCreateDirectorBase
      DIRECTOR_EVENT = 'costs.created'

      register_event(DIRECTOR_EVENT)

      def create
        super
        cost
      end

      private

      def debt
        @debt ||= Debt.create(user: @user, group: @group, debt_value: 0)
      end

      def cost
        super

        if create_cost_monad
          @cost = create_cost_monad.success
          publish_director_event
        end

        create_cost_monad
      end

      def create_cost_monad
        @create_cost_monad ||= cost_creater.create
      end

      def cost_creater
        @cost_creater ||= Creaters::CostsCreaters::CostCreater.new(
          user,
          cost_value,
          group,
          debt
        )
      end
    end
  end
end
