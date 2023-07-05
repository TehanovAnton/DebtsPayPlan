# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  describe 'POST /groups' do
    def post_group_url(user)
      "/users/#{user.id}/groups"
    end

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
        post(post_group_url(user), params:)

        expect(Group.count).to eq(1)
      end

      it 'has group owner' do
        post(post_group_url(user), params:)

        expect(Group.last.owner).to eq(user)
      end
    end
  end
end
