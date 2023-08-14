# frozen_string_literal: true

module Services
  module DebtSteps
    class BaseDirector
      private

      def subscribe_debter_debt_updater
        subscribe deirector_event do
          debt_updater(debt_step.debter).update
        end
      end

      def subscribe_recipient_debt_updater
        subscribe deirector_event do
          debt_updater(debt_step.recipient).update
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
