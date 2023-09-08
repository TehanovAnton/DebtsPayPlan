# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  include Rails.application.routes.url_helpers

  describe 'POST /groups' do
    before { sign_in group_owner }

    context 'create group' do
      let(:group_owner) do
        FactoryBot.create(:user)
      end

      let(:params) do
        {
          group: {
            name: 'Group 1',
            group_owner_member_attributes: {
              group_memberable_type: group_owner.class.name,
              group_memberable_id: group_owner.id,
              type: 'GroupOwnerMember'
            }
          }
        }
      end

      before { post(groups_path, params:) }

      it 'creates group' do
        expect(Group.count).to eq(1)
      end

      it 'has group owner' do
        expect(Group.last.owner).to eq(group_owner)
      end

      it 'creates zero group cost' do
        expect(Group.last.cost.cost_value).to eq(0.0)
      end
    end
  end
end
