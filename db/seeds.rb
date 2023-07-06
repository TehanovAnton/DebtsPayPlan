groups_count = 2
group_users_count = groups_count * 2

groups = FactoryBot.create_list(:group, groups_count, :with_group_cost)
groups.each do |group|
  group_users_count.times do
    FactoryBot.create(
      :user, 
      :in_group, 
      :with_cost, 
      group:, 
      cost_group: group,
      cost_value: (1..group_users_count^2).to_a.sample
    )
  end

  Updaters::CostsUpdaters::GroupCostUpdater.new(group, group.cost).update
end

