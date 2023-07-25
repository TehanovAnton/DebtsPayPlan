module Services
  module Groups
    class GroupUserAddDirector
      attr_reader :group, :user

      def initialize(group, user)
        @group = group
        @user = user
      end

      def add
        group_member_adder.add
        create_debt
        cost_creater.create
      end

      private

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