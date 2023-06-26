# frozen_string_literal: true

module Seeds
  module Models
    module Users
      module UsersSeed
        extend ActiveSupport::Concern

        included do
          let(:users) do
            FactoryBot.create_list(:user, 2)
          end
        end
      end
    end
  end
end
