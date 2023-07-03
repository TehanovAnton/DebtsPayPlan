# frozen_string_literal: true

module Seeds
  module Builders
    module BuilderModule
      def seed_attribute(seed, attr_name: nil)
        self_return do
          (lambda do
            return @factory_bot_attributes << seed unless attr_name

            @factory_bot_named_attributes[attr_name] = seed
          end).call
        end
      end

      def result
        make_seed
        @seed
      end

      private

      attr_reader :factory_bot_method, :factory_bot_attributes, :factory_bot_named_attributes

      def make_seed
        self_return do
          return @seed if @seed

          @seed = FactoryBot.method(factory_method)
                            .call(factory, *factory_bot_attributes, **factory_bot_named_attributes)
        end
      end

      def self_return
        yield
        self
      end
    end

    class Builder
      include BuilderModule

      def initialize(factory_method, factory)
        @factory_method = factory_method
        @factory = factory
        @factory_bot_attributes = []
        @factory_bot_named_attributes = {}
      end

      private

      attr_reader :factory_method, :factory
    end
  end
end
