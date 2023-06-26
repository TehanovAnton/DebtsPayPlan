# frozen_string_literal: true

module Seeds
  module Builders
    module Groups
      module GroupBuilderModule
        def user_seed_attribute(user_seed)
          @user_seed = user_seed
        end

        def cost_seed_attribute(cost_seed)
          @cost_seed = cost_seed
        end

        private

        attr_reader :user_seed, :cost_seed
      end
    end
  end
end
