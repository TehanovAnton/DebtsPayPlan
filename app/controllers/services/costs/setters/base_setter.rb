# frozen_string_literal: true

module Services
  module Costs
    module Setters
      class BaseSetter
        include SetterMethod

        def initialize(definer)
          @definer = definer
        end
      end
    end
  end
end
