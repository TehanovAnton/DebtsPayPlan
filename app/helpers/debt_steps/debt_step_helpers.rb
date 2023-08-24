# frozen_string_literal: true

module DebtSteps
  module DebtStepHelpers
    def debter_name(debt_step)
      debt_step.debter.name
    end

    def recipient_name(debt_step)
      debt_step.recipient.name
    end

    def pay_value(debt_step)
      debt_step.pay_value
    end

    def users_for_select(group)
      group.users.map { |user| [user.name, user.id] }
    end
  end
end
