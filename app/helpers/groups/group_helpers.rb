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

    def group_user_debt_value(group, user)
      group_user_info_obj = Services::Info::GroupUserInfoService.new(group, user)
      Maybe(group_user_info_obj.debt).fmap(&:debt_value).value_or(0)
    end

    def group_user_row_id(group, user)
      "row-group-#{group.id}-user-#{user.id}"
    end

    def group_user_row_costs_sum_value_element_id(group, user)
      "group-#{group.id}-user-#{user.id}-costs-sum-value-element"
    end

    def group_user_costs_sum(group, user)
      group_user_info_obj = Services::Info::GroupUserInfoService.new(user, group)
      Maybe(group_user_info_obj).fmap(&:costs_sum).value_or(0)
    end

    def group_user_row_debt_value_element_id(group, user)
      "group-#{group.id}-user-#{user.id}-row-debt-value-element"
    end

    def user_costs_table_row_id(user, cost)
      "costs-table-row-#{dom_id user}-#{dom_id cost}"
    end

    def user_looked_group?(group, user)
      Services::Impressions::GroupUserImpression.new(group, user).impressioned?
    end

    def send_join_request?(group, user)
      group.user_join_notifications(user).count.zero?
    end

    def join_requests_link_name(group)
      join_requests_count = group.notifications.where(
        type: GroupJoinRequestNotification.name
      ).count

      "Join requests #{join_requests_count}"
    end

    def in_group?(group, user)
      group.users.include?(user)
    end

    def join_request_rejected?(group, user)
      # binding.pry
      rejection_notifications = Notification.where(
        type: GroupJoinRejectionNotification.name,
        recipient: user
      )

      rejection_notifications.map { |n| n.params[:group].id == group.id }.any?
    end
  end
end
