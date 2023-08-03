# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DebtSteps', type: :request do
  describe 'POST create' do
    let(:user1)  do
      FactoryBot.create(:user, name: 'User 1')
    end

    let(:user2) do
      FactoryBot.create(:user, name: 'User 2')
    end

    let(:group) do
      FactoryBot.create(
        :group,
        :with_group_cost,
        owner: user1,
        add_users: [user2]
      )
    end

    let!(:user1_cost) do
      FactoryBot.create(
        :cost,
        group:,
        costable: user1,
        cost_value: 1
      )
    end

    let!(:user2_cost) do
      FactoryBot.create(
        :cost,
        group:,
        costable: user2,
        cost_value: 3
      )
    end

    let(:params) do
      {
        debt_step: {
          debter_id: user1.id,
          recipient_id: user2.id,
          pay_value: 1
        }
      }
    end

    context 'first debt step in group' do
      it 'creates debt_step' do
        expect do
          post(group_debt_steps_path(group), params:)
        end.to change(DebtStep, :count).by(1)
      end

      it 'creates group_debts_pay_plan' do
        expect do
          post(group_debt_steps_path(group), params:)
        end.to change(GroupDebtsPayPlan, :count).by(1)
      end

      it 'changes debter debt value on pay value' do
        post(group_debt_steps_path(group), params:)
        expect(user1.group_user_debt(group).debt_value).to eq(0)
      end

      it 'changes recipient debt value on pay value' do
        post(group_debt_steps_path(group), params:)
        expect(user2.group_user_debt(group).debt_value).to eq(0)
      end
    end
  end
end
