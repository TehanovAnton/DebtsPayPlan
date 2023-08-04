# frozen_string_literal: true

module Validations
  module Costs
    module Validation
      extend ActiveSupport::Concern

      included do
        validates :cost_value, presence: {
          message: 'could not be empty'
        }

        validates :cost_value, numericality: {
          greater_than: 0,
          message: 'cant be equal and less then zero'
        }, if: proc { |cost| cost.type == 'Cost' }

        validates :cost_value, numericality: {
          less_than: 1000,
          message: 'should not has more then three-digit before decimal digit and more then two digits after'
        }
      end
    end
  end
end
