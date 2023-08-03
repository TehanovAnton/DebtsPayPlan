# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Costs', type: :request do
  describe 'POST user_group_costs' do
    include_context 'post group_owner cost'

    context 'first cost in group' do
      it 'creates cost' do
        post(user_group_costs_path(group_owner, group), params:)
        expect(Cost.count).to eq(2)
      end
    end

    describe 'debt' do
      include_context 'post group_owner cost'

      context 'first cost in group' do
        it 'creates group user debt' do
          post(user_group_costs_path(group_owner, group), params:)
          expect(group_owner.group_user_debt(group)).to be
        end
      end
    end

    describe 'group_user_step_state' do
      context 'first cost in group' do
        include_context 'post group_owner cost'

        it 'creates group_user_step_state' do
          expect do
            post(user_group_costs_path(group_owner, group), params:)
          end.to change(GroupUserStepState.all, :count)
            .by(1)
        end
      end

      context 'not first cost in group' do
        include_context 'post group_owner cost'

        it 'updates group_user_step_state' do
          2.times do
            post(user_group_costs_path(group_owner, group), params:)
          end

          group_owner_step_state = group_owner.group_user_step_state(group)

          expect(group_owner_step_state.cost_ids.count).to eq(2)
        end
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
