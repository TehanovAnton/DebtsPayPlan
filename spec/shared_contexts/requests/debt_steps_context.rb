# frozen_string_literal: true

RSpec.shared_context 'group debter and recipient' do
  include_context 'group context' do
    let(:debter) do
      group_owner
    end

    let(:recipient) do
      FactoryBot.create(
        :user,
        in_group: group
      )
    end
  end
end

RSpec.shared_context 'debter and recipient costs' do |debter_cv, recipient_cv|
  let!(:debter_cost) do
    FactoryBot.create(
      :cost,
      costable: debter,
      cost_value: debter_cv || 1,
      group:
    )
  end

  let!(:recipient_cost) do
    FactoryBot.create(
      :cost,
      costable: recipient,
      cost_value: recipient_cv || 3,
      group:
    )
  end
end

RSpec.shared_context 'debt step post params' do |pay_value_param|
  let(:pay_value) { pay_value_param }

  let(:params) do
    {
      debt_step: {
        debter_id: debter.id,
        recipient_id: recipient.id,
        pay_value:
      }
    }
  end
end
