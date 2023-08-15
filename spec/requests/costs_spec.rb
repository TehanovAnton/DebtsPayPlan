# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'redirect to' do |redirect_path_name|
  it "redirects to #{redirect_path_name}" do
    response = post(user_group_costs_path(group_owner, group), params:)

    expect(response).to redirect_to(redirect_path)
  end
end

RSpec.shared_examples 'request redirects to' do |redirect_path_name, action|
  it "redirects to #{redirect_path_name}" do
    response = method(action).call(request_path, params:)

    expect(response).to redirect_to(redirect_path)
  end
end

RSpec.shared_examples 'sets propper flash message' do |action, flash_key|
  it 'sets propper flash message' do
    method(action).call(
      request_path,
      params:
    )
    expect(flash[flash_key]).to match(flash_message)
  end
end

RSpec.shared_examples 'updates group cost' do |action|
  it 'updates group cost' do
    method(action).call(request_path, params:)

    group.reload

    expect(group.cost.cost_value).to eq(updated_group_cost_value)
  end
end

RSpec.shared_examples 'updates group users debts' do |action|
  it 'updates group users debts' do
    method(action).call(request_path, params:)

    group.reload

    users.each do |uesr|
      group_user_info = Services::Info::GroupUserInfoService.new(uesr, group)
      expect(group_user_info.debt.debt_value).to eq(group_user_info.callculate_debt_value)
    end
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

      include_examples 'updates group cost', :post do
        let(:request_path) { user_group_costs_path(user2, group) }
        let(:updated_group_cost_value) { 2 }
      end

      include_examples 'updates group users debts', :post do
        let(:request_path) { user_group_costs_path(user2, group) }
        let(:users) { [user1, user2] }
      end
    end

    context 'invalid cost params' do
      before { sign_in group_owner }

      include_context 'post group_owner cost params'

      let(:request_path) { user_group_costs_path(group_owner, group) }

      context do
        let(:cost_value) { nil }

        include_examples 'redirect to', 'new cost page' do
          let(:redirect_path) { user_group_costs_path(group_owner, group) }
        end
      end

      context 'nil cost value' do
        let(:cost_value) { nil }

        include_examples 'sets propper flash message', :post, :error do
          let(:flash_message) { 'Cost value could not be empty' }
        end
      end

      context '0 cost value' do
        let(:cost_value) { 0 }

        include_examples 'sets propper flash message', :post, :error do
          let(:flash_message) { 'Cost value cant be equal and less then zero' }
        end
      end

      context 'cost value in wrong range' do
        context 'more then free digits before digit point' do
          let(:cost_value) { 1000 }

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) do
              'Cost value should not has more then three-digit before decimal point and more then two digits after'
            end
          end
        end

        context 'negative value' do
          let(:cost_value) { -1 }

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) do
              'cant be equal and less then zero'
            end
          end
        end
      end
    end
  end

  describe 'PUT user_group_cost_path' do
    before { sign_in group_owner }

    include_context 'group context' do
      let(:cost_value) { 1 }
      let(:udpate_cost_value) { 2 }

      let!(:cost) do
        FactoryBot.create(
          :cost,
          costable: group_owner,
          cost_value:,
          group:
        )
      end

      let(:params) do
        {
          cost: {
            cost_value: udpate_cost_value
          }
        }
      end
    end

    context 'valid update' do
      let(:request_path) { user_group_cost_path(group_owner, group, cost) }

      include_examples 'redirect to', 'group page' do
        let(:redirect_path) { group_path(group, user_id: group_owner.id) }
      end

      include_examples 'updates group cost', :put do
        let(:updated_group_cost_value) { 2 }
      end

      include_examples 'updates group users debts', :put do
        let(:users) { [group_owner] }
      end

      it 'updates cost' do
        put(user_group_cost_path(group_owner, group, cost), params:)

        expect(cost.reload.cost_value).to eq(udpate_cost_value)
      end
    end

    context 'invalid update' do
      let(:request_path) { user_group_cost_path(group_owner, group, cost) }

      let(:udpate_cost_value) { nil }

      include_examples 'request redirects to', 'edit cost page', :put do
        let(:redirect_path) { edit_user_group_cost_path(group_owner, group, cost) }
      end

      context 'empty cost value' do
        let(:udpate_cost_value) { nil }

        include_examples 'sets propper flash message', :put, :error do
          let(:flash_message) { 'Cost value could not be empty' }
        end
      end

      context 'zero cost value' do
        let(:udpate_cost_value) { 0 }

        include_examples 'sets propper flash message', :put, :error do
          let(:flash_message) { 'Cost value cant be equal and less then zero' }
        end
      end

      context 'cost value in wrong range' do
        let(:udpate_cost_value) { 1000 }

        include_examples 'sets propper flash message', :put, :error do
          let(:flash_message) do
            'Cost value should not has more then three-digit before decimal point and more then two digits after'
          end
        end
      end

      context 'megative cost value' do
        let(:udpate_cost_value) { -1 }

        include_examples 'sets propper flash message', :put, :error do
          let(:flash_message) { 'Cost value cant be equal and less then zero' }
        end
      end
    end
  end

  describe 'DELETE user_group_cost_path' do
    before { sign_in group_owner }

    include_context 'group context' do
      let(:cost_value) { 1 }

      let!(:cost) do
        FactoryBot.create(
          :cost,
          costable: group_owner,
          cost_value:,
          group:
        )
      end

      let(:request_path) { user_group_cost_path(group_owner, group, cost) }

      let(:updated_group_cost_value) { 0 }

      let(:params) {}

      let(:users) { [group_owner] }
    end

    include_examples 'updates group cost', :delete
    include_examples 'updates group users debts', :delete

    it 'destroys user cost' do
      delete(request_path)

      expect(Cost.exists?(cost.id)).to be(false)
    end
  end
end
