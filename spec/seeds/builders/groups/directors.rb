module Seeds::Builders::Groups
  class GroupDiretor
    def initialize(group_builder, users, cost)
      @users = users
      @costs = cost
      @group_builder = group_builder
    end

    def make_group
      group_builder.seed_attribute(user_seed.result, attr_name: :users)
                   .seed_attribute(cost_seed.result, attr_name: :cost_attributes)
    end
  end
end
