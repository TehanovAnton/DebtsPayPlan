require 'rails_helper'

RSpec.describe Cost, type: :model do
  describe 'associations' do
    describe 'user' do
      context 'correct params' do
        let(:cost) do
          user_seed = Seeds::Models::Users::UserSeed.new
          Seeds::Models::Costs::CostSeed.new(user_seed).create
        end

        it 'creates cost' do
          expect(cost.user).to be
        end
      end
    end
  end
end
