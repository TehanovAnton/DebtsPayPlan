users = FactoryBot.create_list(:user, 5)
owner = users.first

group = FactoryBot.create(
  :group,
  owner:,
  add_users: users - [owner]
)
users.each do |user|
  FactoryBot.create(
    :cost,
    costable: user,
    cost_value: (1..20).to_a.sample,
    group:
  )
end
