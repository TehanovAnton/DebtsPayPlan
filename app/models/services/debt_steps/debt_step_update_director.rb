# frozen_string_literal: true

module Services
  module DebtSteps
    class DebtStepUpdateDirector < BaseDirector
      include Dry::Events::Publisher[:debt_step_update_deirector_publisher]

      attr_reader :debt_step, :group, :update_params

      DIRECTOR_EVENT = 'debt_step.updated'

      register_event(DIRECTOR_EVENT)

      def initialize(debt_step, group, update_params)
        super()

        @debt_step = debt_step
        @group = group
        @update_params = update_params
      end

      def udpate
        subscribe_debter_debt_updater
        subscribe_recipient_debt_updater
        publish_director_event if update_monad.success?
        update_monad
      end

      private

      def update_monad
        @update_monad ||= Updaters::DebtStepsUpdaters::DebtStepUpdater.new(debt_step, update_params).update_monad
      end

      def debt_updater(user)
        case user
        when debt_step.debter
          @debter_debt_updater ||= Updaters::DebtsUpdaters::DebtUpdater.new(group, debt_step.debter)
        when debt_step.recipient
          @recipient_debt_updater ||= Updaters::DebtsUpdaters::DebtUpdater.new(group, debt_step.recipient)
        end
      end
    end
  end
end
