module Seeds
  module Builders
    module Groups
      module GroupBuilderModule
        def set_users(user_seed)
          @user_seed = user_seed
        end

        def set_cost_attributes(cost_seed)
          @cost_seed = cost_seed
        end

        private

        attr_reader :user_seed, :cost_seed
      end
    end
  end
end

