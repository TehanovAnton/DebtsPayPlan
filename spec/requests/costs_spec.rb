# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Costs', type: :request do
  describe 'POST /groups/:group_id/users/:user_id/costs' do
    context 'create first group cost' do
      let!(:user) do
        FactoryBot.create(:user)
      end

      let!(:group) do
        FactoryBot.create(:group)
      end

      let(:params) do
        {
          cost: {
            group_member_attributes: { group_id: group.id },
            costable_type: user.class.name,
            costable_id: user.id,
            cost_value: 1
          }
        }
      end

      let(:post_cost_url) { "/groups/#{group.id}/users/#{user.id}/costs" }

      it 'creates cost' do
        post(post_cost_url, params:)

        expect(Cost.count).to eq(2)
      end

      it 'group has cost' do
        post(post_cost_url, params:)
        expect(group.reload.cost.cost_value).to eq(Cost.last.cost_value)
      end
    end
  end
end
