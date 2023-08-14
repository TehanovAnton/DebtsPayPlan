# frozen_string_literal: true

module Updaters
  module DebtsUpdaters
    class DebtUpdater
      attr_reader :group, :user

      def initialize(group, user)
        @group = group
        @user = user
      end

      def update
        debt.update(debt_value: callculate_debt_value)
      end

      def debt
        @debt = group_user_info.debt
      end

      private

      def callculate_debt_value
        group_user_info.callculate_debt_value
      end

      def group_user_info
        @group_user_info ||= Services::Info::GroupUserInfoService.new(user, group)
      end
    end
  end
end
