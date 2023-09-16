# frozen_string_literal: true

module Services
  module Costs
    module ControllerParams
      class UpdateControllerParams < BaseControllerParams
        def params
          @controller_params.require(:cost)
                            .permit(
                              :cost_value
                            )
        end
      end
    end
  end
end
