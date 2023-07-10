# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  include Rails.application.routes.url_helpers

  describe 'POST /groups' do
    context 'create group' do
      let(:user) do
        FactoryBot.create(:user)
      end

      let(:params) do
        {
          group: {
            name: 'Group 1',
            group_owner_member_attributes: {
              group_memberable_type: user.class.name,
              group_memberable_id: user.id,
              type: 'GroupOwnerMember'
            }
          }
        }
      end

      it 'creates group' do
        post(user_groups_path(user), params:)

        expect(Group.count).to eq(1)
      end

      it 'has group owner' do
        post(user_groups_path(user), params:)

        expect(Group.last.owner).to eq(user)
      end

      it 'creates zero group cost' do
        post(user_groups_path(user), params:)

        expect(Group.last.cost.cost_value).to be(0)
      end
    end
  end

  describe 'PUT ' do
    context 'add first user' do
      let(:group) do
        FactoryBot.create(:group)
      end

      let(:user) do
        FactoryBot.create(:user)
      end

      it 'adds user to group' do
        post(add_user_member_user_group_path(user, group))

        expect(group.users).to include(user)
      end

      it 'creates zero cost for user' do
        post(add_user_member_user_group_path(user, group))

        expect(user.group_user_cost(group).cost_value).to be(0)
      end

      it 'creates zero user debt' do
        post(add_user_member_user_group_path(user, group))

        expect(user.group_user_debt(group).debt_value).to be(0.0)
      end
    end
  end
end
