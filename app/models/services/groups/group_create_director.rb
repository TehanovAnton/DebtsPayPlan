module Services
  module Groups
    class GroupCreateDirector
      attr_reader :owner, :name, :group, :debt

      def initialize(name, owner)
        @owner = owner
        @name = name
      end

      def create
        create_group
        create_debt
        cost_creater.create
        group_cost_creater.create
        group_users_debts_updater.update
        group_users_debts_updater.update
      end

      private

      def create_group
        @group = Group.create(name:, owner:)
      end

      def create_debt
        @debt = Debt.create(
          user: owner,
          debt_value: 0,
          group:
        )
      end

      def cost_creater
        @cost_creater ||= Creaters::CostsCreaters::CostCreater.new(
          owner,
          0,
          group,
          debt
        )
      end

      def group_cost_creater
        @group_cost_creater ||= Creaters::CostsCreaters::GroupCostCreater.new(group)
      end

      def group_users_debts_updater
        @group_users_debts_updater ||= Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(group)
      end
    end
  end
end