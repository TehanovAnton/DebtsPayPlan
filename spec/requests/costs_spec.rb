# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Costs', type: :request do
  describe 'POST /groups/:group_id/users/:user_id/costs' do
    context 'create first group cost' do
      let!(:user) do
        FactoryBot.create(:user)
      end

      let!(:group) do
        FactoryBot.create(
          :group,
          owner: user
        )
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

      it 'creates cost' do
        post(user_group_costs_path(user, group), params:)
        expect(Cost.count).to eq(2)
      end

      it 'creates group user debt' do
        post(user_group_costs_path(user, group), params:)
        expect(user.group_user_debt(group)).to be
      end
    end

    context 'create not first group cost' do
      let!(:user1) do
        FactoryBot.create(
          :user,
          name: 'User 1'
        )
      end

      let!(:user2) do
        FactoryBot.create(
          :user,
          name: 'User 2'
        )
      end

      let!(:group) do
        FactoryBot.create(
          :group,
          owner: user1,
          add_users: [user2],
          name: 'Group 1'
        )
      end

      let!(:user1_cost) do
        FactoryBot.create(
          :cost,
          costable: user1,
          cost_value: 1,
          group:
        )
      end

      let(:params) do
        {
          cost: {
            costable_type: user2.class.name,
            costable_id: user2.id,
            cost_value: 3
          }
        }
      end

      it 'updates group cost' do
        post(user_group_costs_path(user2, group), params:)
        expect(group.reload.cost.cost_value).to eq(2)
      end

      it 'updates group users debts' do
        post(user_group_costs_path(user2, group), params:)
        group.reload

        [user1, user2].each do |uesr|
          group_user_info = Services::Info::GroupUserInfoService.new(uesr, group)

          expect(group_user_info.debt.debt_value).to be(group_user_info.callculate_debt_value)
        end
      end
    end
  end
end
