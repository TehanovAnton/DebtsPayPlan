# frozen_string_literal: true

module Updaters
  module DebtsUpdaters
    class GroupUsersDebtsUpdater
      attr_reader :group

      def initialize(group)
        @group = group
      end

      def update
        group.users.each do |user|
          group_user_info = Services::Info::GroupUserInfoService.new(user, group)

          debt_value = group_user_info.callculate_debt_value
          debt_params = { debt_value: }
          next group_user_info.debt.update(**debt_params) if group_user_info.debt

          Debt.create(user:, group: group_user_info.group, debt_value:)
        end
      end
    end
  end
end
