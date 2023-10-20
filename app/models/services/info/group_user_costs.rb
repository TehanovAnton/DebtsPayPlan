module Services
  module Info
    class GroupUserCosts < GroupUserInfo
      def info
        user.costs.joins(:group)
            .where(
              costs: { costable_type: user.class.name, costable_id: user.id },
              groups: { id: group.id }
            )
      end
    end
  end
end