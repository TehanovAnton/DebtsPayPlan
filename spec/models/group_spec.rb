# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'association' do
    describe 'users' do
      context 'correct params' do
        let!(:group) do
          users_seed = Seeds::Builders::Users::UsersListBuilder.new(:create_list, :user)
                                                               .seed_attribute(1)
          cost_seed = Seeds::Builders::Costs::GroupCostAttributesBuilder.new('', '')
                                                                        .seed_attribute(0, attr_name: :cost_value)
          group_builder = Seeds::Builders::Groups::SettableFactory::GroupBuilder.new(:create, :group)
          group_builder.seed_attribute(users_seed.result, attr_name: :users)
                       .seed_attribute(cost_seed.result, attr_name: :cost_attributes)
                       .result
        end

        it 'create group with users' do
          expect(group.users).not_to be_empty
        end
      end
    end

    describe 'cost' do
      context 'creating group' do
        let(:group) do
          user_seed = Seeds::Builders::Users::UsersListBuilder.new(1)
          cost_seed = Seeds::Builders::Costs::GroupCostAttributesBuilder.new
          group_builder = Seeds::Builders::Groups::SettableFactory::GroupBuilder.new
          group_builder.factory_bot_method_attribute(:create)
                       .seed_attribute(:group)
                       .seed_attribute(user_seed.result, attr_name: :users)
                       .seed_attribute(cost_seed.result, attr_name: :cost_attributes)
                       .result
        end

        it 'creates cost with group as costable' do
          expect(group.cost).not_to be_nil
        end
      end

      context 'creating group without cost' do
        let(:group) do
          user_seed = Seeds::Builders::Users::UsersListBuilder.new(1)
          group_builder = Seeds::Builders::Groups::SettableFactory::GroupBuilder.new
          group_builder.factory_bot_method_attribute(:build)
                       .seed_attribute(:group)
                       .seed_attribute(user_seed.result, attr_name: :users)
                       .seed_attribute({}, attr_name: :cost_attributes)
                       .result
        end

        it 'will not create group cost' do
          expect(group).not_to be_valid
        end
      end
    end
  end
end
