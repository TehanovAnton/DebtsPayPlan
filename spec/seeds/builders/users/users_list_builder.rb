# frozen_string_literal: true

module Seeds
  module Builders
    module Users
      class UsersListBuilder < Builders::Builder
        def result
          super
          User.where(id: @seed.pluck(:id))
        end
      end
    end
  end
end
