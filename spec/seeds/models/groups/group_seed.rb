# frozen_string_literal: true

module Seeds
  module Models
    module Groups
      class GroupSeed
        def initialize(users_seed)
          @users_seed = users_seed
        end

        def create
          @group = FactoryBot.create(:group, users: @users_seed.users_collection)
        end
      end
    end
  end
end
