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

      module SettableFactory
        class GroupBuilder < Seeds::Builders::Builder
          def initialize(factory_method, factory)
            super(factory_method, factory)
            @factory_bot_attributes = []
            @factory_bot_named_attributes = {}
          end

          def seed_attribute(seed, attr_name: nil)
            self_return { super }
          end

          def factory_bot_method_attribute(factory_bot_method)
            self_return { super }
          end
        end
      end
    end
  end
end
