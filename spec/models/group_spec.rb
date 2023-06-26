# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'association' do
    describe 'users' do
      context 'correct params' do
        let!(:group) do
          user_seed = Seeds::Models::Users::UserSeed.new(1)
          group_builder = Seeds::Builders::Groups::GroupBuilder.new
          group_builder.user_seed_attribute(user_seed)
          group_builder.cost_seed_attribute(Seeds::Models::Costs::CostSeed.new(user_seed))
          group_builder.make_seed
        end

        it 'create group with users' do
          expect(group.users).not_to be_empty
        end
      end
    end

    describe 'cost' do
      context 'creating group' do
        let(:group) do
          user_seed = Seeds::Models::Users::UserSeed.new
          group_builder = Seeds::Builders::Groups::GroupBuilder.new
          group_builder.user_seed_attribute(user_seed)
          group_builder.cost_seed_attribute(Seeds::Models::Costs::CostSeed.new(user_seed))
          group_builder.make_seed
        end

        it 'creates cost with group as costable' do
          expect(group.cost).not_to be_nil
        end
      end

      context 'creating group without cost' do
        let(:group) do
          user_seed = Seeds::Models::Users::UserSeed.new
          group_builder = Seeds::Builders::Groups::NoCostAttributesGroupBuilder.new
          group_builder.user_seed_attribute(user_seed)
          group_builder.build_seed
        end

        it 'will not create groupcost' do
          expect(group).not_to be_valid
        end
      end
    end
  end
end