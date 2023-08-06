# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'redirect to' do |redirect_path_name|
  it "redirects to #{redirect_path_name}" do
    response = post(user_group_costs_path(group_owner, group), params:)

    expect(response).to redirect_to(redirect_path)
  end
end

RSpec.shared_examples 'sets propper flash message' do |flash_key|
  it 'sets propper flash message' do
    post(user_group_costs_path(group_owner, group), params:)
    expect(flash[flash_key]).to match(flash_message)
  end
end

RSpec.describe 'Costs', type: :request do
  describe 'POST user_group_costs' do
    include_context 'post group_owner cost'

    context 'first cost in group' do
      before { sign_in group_owner }

      it 'creates cost' do
        post(user_group_costs_path(group_owner, group), params:)
        expect(Cost.count).to eq(2)
      end

      it 'redirects to group page' do
        response = post(user_group_costs_path(group_owner, group), params:)
        expect(response).to redirect_to(
          group_path(group, user_id: group_owner.id)
        )
      end
    end

    describe 'debt' do
      include_context 'post group_owner cost'

      context 'first cost in group' do
        before { sign_in group_owner }

        it 'creates group user debt' do
          post(user_group_costs_path(group_owner, group), params:)
          expect(group_owner.group_user_debt(group)).to be
        end
      end
    end

    context 'create not first group cost' do
      before { sign_in group_owner }

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

          expect(group_user_info.debt.debt_value).to eq(group_user_info.callculate_debt_value)
        end
      end
    end

    context 'invalid cost params' do
      before { sign_in group_owner }

      include_context 'post group_owner cost params'

      context do
        let(:cost_value) { nil }

        include_examples 'redirect to', 'new cost page' do
          let(:redirect_path) { user_group_costs_path(group_owner, group) }
        end
      end

      context 'nil cost value' do
        let(:cost_value) { nil }

        include_examples 'sets propper flash message', :error do
          let(:flash_message) { 'Cost value could not be empty' }
        end
      end

      context '0 cost value' do
        let(:cost_value) { 0 }

        include_examples 'sets propper flash message', :error do
          let(:flash_message) { 'Cost value cant be equal and less then zero' }
        end
      end

      context 'cost value in wrong range' do
        context 'more then free digits before digit point' do
          let(:cost_value) { 1000 }

          include_examples 'sets propper flash message', :error do
            let(:flash_message) do
              'Cost value should not has more then three-digit before decimal digit and more then two digits after'
            end
          end
        end

        context 'negative value' do
          let(:cost_value) { -1 }

          include_examples 'sets propper flash message', :error do
            let(:flash_message) do
              'cant be equal and less then zero'
            end
          end
        end
      end
    end
  end
end
