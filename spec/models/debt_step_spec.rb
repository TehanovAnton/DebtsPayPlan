require 'rails_helper'

RSpec.describe DebtStep, type: :model do
  describe 'associations' do
    it { should validate_presence_of(:group_debts_pay_plan) }
    it { should validate_presence_of(:debter) }
    it { should validate_presence_of(:recipient) }

    let(:group) do
      FactoryBot.create(
        :group,
        :with_group_cost
      )
    end

    let(:users) do
      users = FactoryBot.create_list(:user, 2, :in_group)

      costs_values = [1, 3]
      users.each_with_index do |user, i|
        FactoryBot.create(:cost, costable: user, group:, cost_value: costs_values[i])
      end

      Creaters::CostsCreaters::GroupCostCreater.new(group).create
      Updaters::DebtsUpdaters::GroupUsersDebtsUpdater.new(group).update

      users
    end

    let(:group_debts_pay_plan) do
      FactoryBot.create(:group_debts_pay_plan, group:)
    end

    let(:debt_step) do
      FactoryBot.create(:debt_step, debter: users.first, recipient: users.last, group_debts_pay_plan:)
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
        let(:association) { users.first }
      end
    end

    describe 'recipient' do
      include_examples 'belong to association check' do
        let(:association_name) { :recipient }
        let(:model_association) { debt_step.recipient }
        let(:association) { users.last }
      end
    end
  end
end
