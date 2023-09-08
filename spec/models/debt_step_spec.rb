# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DebtStep, type: :model do
  describe 'associations' do
    let!(:user1) { FactoryBot.create(:user, name: 'User 1') }
    let!(:user2) { FactoryBot.create(:user, name: 'User 2') }

    let!(:group) do
      FactoryBot.create(
        :group,
        owner: user1,
        add_users: [user2]
      )
    end

    let!(:costs) do
      users = group.users

      costs_values = [1, 3]
      users.each_with_index do |user, i|
        FactoryBot.create(:cost, costable: user, group:, cost_value: costs_values[i])
      end
    end

    let!(:group_debts_pay_plan) do
      FactoryBot.create(:group_debts_pay_plan, group:)
    end

    let!(:debt_step) do
      FactoryBot.create(:debt_step, debter: user1, recipient: user2, pay_value: 1, group_debts_pay_plan:)
    end

    describe 'group_debts_pay_plan' do
      include_examples 'belong to association check' do
        let(:association_name) { :group_debts_pay_plan }
        let(:model_association) { debt_step.group_debts_pay_plan }
        let(:association) { group_debts_pay_plan }
      end
    end

    describe 'debter' do
      include_examples 'belong to association check' do
        let(:association_name) { :debter }
        let(:model_association) { debt_step.debter }
        let(:association) { user1 }
      end
    end

    describe 'recipient' do
      include_examples 'belong to association check' do
        let(:association_name) { :recipient }
        let(:model_association) { debt_step.recipient }
        let(:association) { user2 }
      end
    end
  end
end
