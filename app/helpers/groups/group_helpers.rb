# frozen_string_literal: true

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

    def group_user_info(user, group)
      Services::Info::GroupUserInfoService.new(user, group)
    end

    def user_row_activity_class(user, cur_user)
      user == cur_user ? row_active_class : ''
    end

    def row_active_class
      'table-active'
    end

    def group_user_debt_value(group_user_info_obj)
      Maybe(group_user_info_obj.debt).fmap(&:debt_value).value_or('')
    end

    def group_user_row_id(group, user)
      "row-group-#{group.id}-user-#{user.id}"
    end
  end
end
