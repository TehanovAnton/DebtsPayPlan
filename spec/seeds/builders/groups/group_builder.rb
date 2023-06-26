# frozen_string_literal: true

module Seeds
  module Builders
    module Groups
      class GroupBuilder
        include Groups::GroupBuilderModule

        def make_seed
          FactoryBot.create(
            :group,
            users: user_seed.users_collection,
            cost_attributes: cost_seed.group_cost_attributes
          )
        end
      end

      class NoCostAttributesGroupBuilder
        include Groups::GroupBuilderModule

        def make_seed
          FactoryBot.create(
            :group,
            users: user_seed.users_collection
          )
        end

        def build_seed
          FactoryBot.build(
            :group,
            users: user_seed.users_collection
          )
        end
      end
    end
  end
end
