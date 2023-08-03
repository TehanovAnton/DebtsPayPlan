# frozen_string_literal: true

module Services
  module DebtSteps
    class DebtStepDestroyDirector < DestroyDirector
      attr_reader :debt_step, :group

      include Dry::Events::Publisher[:debt_steps_destroy_deirector_publisher]

      DESTROY_EVENT_NAME = 'debt_steps.destroyed'

      register_event(DESTROY_EVENT_NAME)

      def initialize(debt_step, group: debt_step.group)
        super()

        @debt_step = debt_step
        @group = group
      end

      private

      def publish_destroy
        publish(DESTROY_EVENT_NAME)
      end

      def subscribe_listeners
        subscribe(DESTROY_EVENT_NAME) do
          group_debts_updater.update
        end
      end

      def destroyer
        @destroyer ||= Destroyers::DebtSteps::DebtStepDestroyer.new(debt_step)
      end

      def group_debts_updater
        Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(group)
      end
    end
  end
end
