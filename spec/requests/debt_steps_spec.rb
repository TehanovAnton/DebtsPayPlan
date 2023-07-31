# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DebtSteps', type: :request do
  describe 'POST create' do
    include_context 'group debter and recipient' do
      let!(:debter_cost) do
        FactoryBot.create(
          :cost,
          group:,
          costable: debter,
          cost_value: 1
        )
      end

      let!(:recipient_cost) do
        FactoryBot.create(
          :cost,
          group:,
          costable: recipient,
          cost_value: 3
        )
      end

      let(:params) do
        {
          debt_step: {
            debter_id: debter.id,
            recipient_id: recipient.id,
            pay_value: 1
          }
        }
      end
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
        expect(debter.group_user_debt(group).debt_value).to eq(0)
      end

      it 'changes recipient debt value on pay value' do
        post(group_debt_steps_path(group), params:)
        expect(recipient.group_user_debt(group).debt_value).to eq(0)
      end
    end
  end
end
