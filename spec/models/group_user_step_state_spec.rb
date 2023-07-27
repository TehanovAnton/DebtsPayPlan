# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupUserStepState, type: :model do
  describe do
    let(:user) do
      FactoryBot.create(:user)
    end

    let!(:group) do
      FactoryBot.create(
        :group,
        :with_group_cost,
        owner: user
      )
    end

    let(:cost1) do
      FactoryBot.create(
        :cost,
        costable: user,
        cost_value: 1,
        group:
      )
    end

    let!(:step_state) do
      FactoryBot.create(
        :group_user_step_state,
        group:,
        user:
      )
    end

    it do
    end
  end
end
