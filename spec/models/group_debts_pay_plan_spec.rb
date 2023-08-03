# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupDebtsPayPlan, type: :model do
  describe 'associations' do
    describe 'group' do
      let(:group) do
        FactoryBot.create(:group)
      end

      let(:group_debts_pay_plan) do
        FactoryBot.create(:group_debts_pay_plan, group:)
      end

      include_examples 'have one association check' do
        let!(:association) { group }
        let!(:association_name) { :group }
        let!(:model) { group_debts_pay_plan }
      end

      it { should validate_presence_of(:group_debts_pay_plan_member) }
      it { should validate_presence_of(:group) }
    end
  end

  describe 'debt_steps' do
    let(:group) { FactoryBot.create(:group) }
    let(:users) { FactoryBot.create_list(:user, 2, in_group: group) }
    let(:group_debts_pay_plan) { FactoryBot.create(:group_debts_pay_plan, group:) }
    let(:debt_step) do
      FactoryBot.create(:debt_step, debter: users.first, recipient: users.last, group_debts_pay_plan:)
    end

    include_examples 'have many association check' do
      let!(:association) { Array.new(1, debt_step) }
      let!(:model_association) { group_debts_pay_plan.debt_steps.to_a }
      let!(:association_name) { :debt_steps }
    end
  end
end
