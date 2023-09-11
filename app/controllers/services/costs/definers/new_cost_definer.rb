# frozen_string_literal: true

module Services
  module Costs
    module Definers
      class NewCostDefiner
        include Costs::DefinerMethod

        def define
          Cost.new
        end
      end
    end
  end
end
