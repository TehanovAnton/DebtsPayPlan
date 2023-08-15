# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'request redirects to' do |redirect_path_name, action|
  let(:redirect_uri) { URI.parse(redirect_path) }
  let(:response_uri) { URI.parse(response.location) }

  it "redirects to #{redirect_path_name}" do
    method(action).call(request_path, params:)

    expect(response_uri.path).to eql(redirect_uri.path)
  end
end

RSpec.shared_examples 'sets propper flash message' do |action, flash_key|
  it 'sets propper flash message' do
    method(action).call(request_path, params:)

    expect(flash[flash_key]).to match(flash_message)
  end
end

RSpec.shared_examples 'debt step change common specs' do |action, change_value_name|
  it "changes debter debt value on #{change_value_name}" do
    old_debt = Services::Info::GroupUserInfoService.new(debter, group).debt.debt_value
    method(action).call(request_path, params:)

    new_debt = Services::Info::GroupUserInfoService.new(debter, group).debt.debt_value
    expect(new_debt).to eq(old_debt + debt_decrease * comparable_value)
  end

  it "changes recipient debt value on #{change_value_name}" do
    old_debt = Services::Info::GroupUserInfoService.new(recipient, group).debt.debt_value
    method(action).call(request_path, params:)

    new_debt = Services::Info::GroupUserInfoService.new(recipient, group).debt.debt_value
    expect(new_debt).to eq(old_debt - debt_decrease * comparable_value)
  end
end

RSpec.shared_examples 'debt step post common specs' do
  let(:request_path) { group_debt_steps_path(group) }

  let(:debt_decrease) { 1 }

  let(:comparable_value) { pay_value }

  include_examples 'debt step change common specs', :post, 'debt step value'

  it 'creates debt_step' do
    expect do
      post(request_path, params:)
    end.to change(DebtStep, :count).by(1)
  end
end

RSpec.shared_examples 'debt step put common specs' do
  let(:request_path) { group_debt_step_path(group, debt_step) }

  include_examples 'debt step change common specs', :put, 'debt step value'

  it 'updates pay_value on pay_value param' do
    put(request_path, params:)

    expect(debt_step.reload.pay_value).to eq(update_debt_step_value)
  end
end

RSpec.shared_examples 'debt step delete common specs' do
  include_examples 'debt step change common specs', :delete, 'debt step value'

  let(:debt_decrease) { -1 }

  let(:comparable_value) { debt_step.pay_value }

  it 'destroyes debt step' do
    delete(request_path)

    expect(DebtStep.exists?(debt_step.id)).to be(false)
  end
end

RSpec.describe 'DebtSteps', type: :request do
  describe 'POST create' do
    describe 'Positive scenario' do
      include_context 'group debter and recipient' do
        include_context 'debter and recipient costs'
        include_context 'debt step post params', 1

        let(:pay_value) { params[:debt_step][:pay_value] }
      end

      context 'first debt step in group' do
        include_examples 'debt step post common specs'

        it 'creates group_debts_pay_plan' do
          expect do
            post(group_debt_steps_path(group), params:)
          end.to change(GroupDebtsPayPlan, :count).by(1)
        end
      end

      context 'not first debt step in group' do
        include_context 'debt step post params', 0.5 do
          let!(:debt_step) do
            FactoryBot.create(
              :debt_step,
              debter:,
              recipient:,
              pay_value:,
              group:
            )
          end

          let(:group_debts_pay_plan) { debt_step.group_debts_pay_plan }

          let(:created_debt_step) { DebtStep.last }

          let(:pay_value) { params[:debt_step][:pay_value] }
        end

        include_examples 'debt step post common specs'

        it 'do not create new group_debts_pay_plan' do
          expect do
            post(group_debt_steps_path(group), params:)
          end.to change(GroupDebtsPayPlan, :count).by(0)
        end

        it 'increase debt steps count in group_debts_pay_plan' do
          expect do
            post(group_debt_steps_path(group), params:)
          end.to change(group_debts_pay_plan.debt_steps, :count).by(1)
        end

        it 'group_debts_pay_plpan include new debt step' do
          post(group_debt_steps_path(group), params:)

          expect(group_debts_pay_plan.debt_steps).to include(created_debt_step)
        end
      end
    end

    describe 'Negative scenarion' do
      include_context 'group debter and recipient' do
        include_context 'debter and recipient costs', 1, 3
        include_context 'debt step post params', 0
      end

      include_examples 'request redirects to', 'new debt step page', :post do
        let(:request_path) { group_debt_steps_url(group) }
        let(:redirect_path) { new_group_debt_step_url(group) }
      end

      describe 'pay_value' do
        include_context 'debter and recipient costs', 1, 3

        context 'empty value' do
          include_context 'debt step post params'
          include_context 'debt step post params', nil

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) { Validations::DebtSteps::Validation::NEGATIVE_PAY_VALUE }
          end
        end

        context 'zero value' do
          include_context 'debt step post params', 0

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) { Validations::DebtSteps::Validation::NEGATIVE_PAY_VALUE }
          end
        end

        context 'negative value' do
          include_context 'debt step post params', -1

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) { Validations::DebtSteps::Validation::NEGATIVE_PAY_VALUE }
          end
        end

        context 'wrong number format' do
          include_context 'debt step post params', 1000

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) { Validations::DebtSteps::Validation::WRONG_NUMBER }
          end
        end
      end

      context 'debter does not debts recipient' do
        context 'recipient debts debter' do
          include_context 'debter and recipient costs', 3, 1
          include_context 'debt step post params', 1

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) { Validations::DebtSteps::DebterDebtsToRecipientValidator::VALIDATION_ERROR_MESSAGE }
          end
        end

        context 'no one debts' do
          include_context 'debter and recipient costs', 1, 1
          include_context 'debt step post params', 1

          include_examples 'request redirects to', 'new debt step page', :post do
            let(:request_path) { group_debt_steps_url(group) }
            let(:redirect_path) { new_group_debt_step_url(group) }
          end

          include_examples 'sets propper flash message', :post, :error do
            let(:flash_message) { Validations::DebtSteps::DebterDebtsToRecipientValidator::VALIDATION_ERROR_MESSAGE }
          end
        end
      end
    end
  end

  describe 'DELETE group_debt_step_path' do
    include_context 'group debter and recipient' do
      include_context 'debter and recipient costs', 1, 3
      include_context 'debter to recipient debt_step', 1

      let(:request_path) { group_debt_step_path(group, debt_step) }

      let(:params) {}
    end

    include_examples 'debt step delete common specs'
  end
end

describe 'PUT group_debt_step_path' do
  describe 'Positive scenarion' do
    describe 'Pay value update' do
      include_context 'group debter and recipient' do
        include_context 'debter and recipient costs', 1, 3
        include_context 'debter to recipient debt_step', 1

        let(:update_debt_step_value) { 0.5 }

        let(:comparable_value) { (debt_step.pay_value - update_debt_step_value).abs }

        let(:debt_decrease) { debt_step.pay_value > update_debt_step_value ? -1 : 1 }

        let(:params) do
          {
            debt_step: { pay_value: update_debt_step_value }
          }
        end
      end

      include_examples 'debt step put common specs'
    end
  end
end
