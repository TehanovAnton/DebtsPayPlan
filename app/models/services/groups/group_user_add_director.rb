# frozen_string_literal: true

module Services
  module Groups
    class GroupUserAddDirector
      attr_reader :group, :user

      include Dry::Monads[:result]

      def initialize(group, user)
        @group = group
        @user = user
      end

      def add
        return failure_monad unless group_member_adder.add?

        success_monad
      end

      private

      def success_monad
        group_member_adder.add
        create_debt
        cost_creater.create
        user_join_requests_notifications.destroy_all

        Success()
      end

      def user_join_requests_notifications
        group.join_notifications.where(params: { user: })
      end

      def failure_monad
        Failure(group_member_adder.error)
      end

      def group_member_adder
        @group_member_adder ||= Creaters::GroupMembersCreaters::GroupMemberAdder.new(
          @user,
          @group
        )
      end

      def create_debt
        Debt.create(
          user: @user,
          debt_value: 0,
          group: @group
        )
      end

      def cost_creater
        @cost_creater ||= Creaters::CostsCreaters::CostCreater.new(
          @user,
          0,
          @group,
          @debt
        )
      end
    end
  end
end
