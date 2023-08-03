# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'associations' do
    describe 'group_debts_pay_plan' do
      let(:group) do
        FactoryBot.create(:group)
      end

      let(:group_debts_pay_plan) do
        FactoryBot.create(:group_debts_pay_plan, group:)
      end

      include_examples 'have one association check' do
        let!(:association) { group_debts_pay_plan }
        let!(:association_name) { :group_debts_pay_plan }
        let!(:model) { group }
      end
    end
  end
end
