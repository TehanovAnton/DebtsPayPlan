# frozen_string_literal: true

module Seeds
  module Builders
    module Users
      class UserBuilder < Builders::Builder
        def result
          create
          @seed
        end

        private

        def create
          return @seed if @seed

          @seed = FactoryBot.create(:user)
        end
      end
    end
  end
end
