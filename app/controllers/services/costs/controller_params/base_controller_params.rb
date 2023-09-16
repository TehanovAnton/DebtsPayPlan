# frozen_string_literal: true

module Services
  module Costs
    module ControllerParams
      class BaseControllerParams
        include ControllerParamsMethod

        def initialize(controller_params)
          @controller_params = controller_params
        end
      end
    end
  end
end
