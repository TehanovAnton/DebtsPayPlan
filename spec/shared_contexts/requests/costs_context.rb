# frozen_string_literal: true

RSpec.shared_context 'group context' do
  let(:group_owner) do
    FactoryBot.create(:user)
  end

  let(:group) do
    FactoryBot.create(
      :group,
      owner: group_owner
    )
  end
end

RSpec.shared_context 'post group_owner cost' do
  include_context 'group context' do
    let(:params) do
      {
        cost: {
          group_member_attributes: { group_id: group.id },
          costable_type: group_owner.class.name,
          costable_id: group_owner.id,
          cost_value: 1
        }
      }
    end
  end
end
