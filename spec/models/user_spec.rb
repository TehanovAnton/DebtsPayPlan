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
  end
end
