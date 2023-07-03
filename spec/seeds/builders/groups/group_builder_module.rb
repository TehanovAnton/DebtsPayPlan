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

        def factory_bot_method_attribute(factory_bot_method)
          @factory_bot_method = factory_bot_method
        end

        private

        attr_reader :user_seed, :cost_seed
      end
    end
  end
end
