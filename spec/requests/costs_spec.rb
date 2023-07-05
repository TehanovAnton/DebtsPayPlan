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

    context 'create not first group cost' do
      let(:group) do
        FactoryBot.create(
          :group,
          :with_group_cost,
          cost_value: 1,
          name: 'Group 1'
        )
      end

      let!(:user1) do
        FactoryBot.create(
          :user,
          :in_group,
          :with_cost,
          cost_value: 1,
          cost_group: group,
          group:,
          name: 'User 1'
        )
      end

      let!(:user2) do
        FactoryBot.create(
          :user,
          :in_group,
          group:,
          name: 'User 2'
        )
      end

      let(:params) do
        {
          cost: {
            group_member_attributes: { group_id: group.id },
            costable_type: user2.class.name,
            costable_id: user2.id,
            cost_value: 3
          }
        }
      end

      def post_cost_url(group, user)
        "/groups/#{group.id}/users/#{user.id}/costs"
      end

      it 'updates group cost' do
        post(post_cost_url(group, user2), params:)
        expect(Group.last.cost.cost_value).to eq(2)
      end
    end
  end
end