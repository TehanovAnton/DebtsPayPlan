# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'invalid cost' do
  it 'is invalid cost' do
    expect(cost).not_to be_valid
  end
end

RSpec.shared_examples 'includes propper error message' do
  it 'includes proper error message' do
    cost.valid?

    expect(cost.errors.full_messages).to include(error_message)
  end
end

RSpec.shared_context 'invalid cost value with error message' do |cost_value, error_message_param|
  let(:cost) do
    FactoryBot.build(
      :cost,
      costable: group_owner,
      cost_value:
    )
  end

  let(:error_message) do
    error_message_param
  end
end

RSpec.describe Cost, type: :model do
  describe 'validation' do
    describe 'cost_value' do
      include_context 'group context'

      context 'invalid record' do
        context 'cost value absents' do
          include_context 'invalid cost value with error message',
                          nil,
                          'Cost value could not be empty'

          include_examples 'invalid cost'
          include_examples 'includes propper error message'
        end

        context 'zero cost value' do
          include_context 'invalid cost value with error message',
                          0,
                          'Cost value cant be equal and less then zero'

          include_examples 'invalid cost'
          include_examples 'includes propper error message'
        end

        context 'cost value has more than three digits before digit point' do
          include_context 'invalid cost value with error message',
                          1234,
                          'Cost value should not has more then three-digit before decimal point and more then ' \
                          'two digits after'

          include_examples 'invalid cost'
          include_examples 'includes propper error message'
        end

        context 'cost value has more than three digits before digit point' do
          include_context 'invalid cost value with error message',
                          -1,
                          'Cost value cant be equal and less then zero'

          include_examples 'invalid cost'
          include_examples 'includes propper error message'
        end
      end
    end
  end
end
