# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    describe 'groups' do
      context 'correct group' do
        let(:user) do
          Seeds::Models::Users::UserSeed.new.create
        end

        let!(:group) do
          users_seed = Seeds::Models::Users::UserSeed.new(1, merge_users: Array.new(1, user))
          Seeds::Models::Groups::GroupSeed.new(users_seed).create
        end

        it 'has group through group member' do
          expect(user.groups).to include(group)
        end
      end
    end

    describe '#group_user_step_state' do
      let(:user) do
        FactoryBot.create(:user)
      end

      let(:group) do
        FactoryBot.create(:group, owner: user)
      end

      let(:cost) do
        FactoryBot.create(
          :cost,
          costable: user,
          group:
        )
      end

      let!(:group_user_step_state) do
        FactoryBot.create(
          :group_user_step_state,
          user:,
          group:
        )
      end

      it 'return group user step state' do
        expect(user.group_user_step_state(group)).to eq(group_user_step_state)
      end
    end
  end
end
