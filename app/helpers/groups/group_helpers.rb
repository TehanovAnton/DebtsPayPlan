module Groups
  module GroupHelpers
    include Dry::Monads[:maybe]

    def debts_pay_plan?(group)
      Maybe(group.group_debts_pay_plan).fmap { true }.value_or(false)
    end

    def debt_steps(group)
      Maybe(group.group_debts_pay_plan).fmap(&:debt_steps).value_or([])
    end

    def group_cost(group)
      Maybe(group.cost).fmap(&:cost_value).value_or(0)
    end
  end
end
