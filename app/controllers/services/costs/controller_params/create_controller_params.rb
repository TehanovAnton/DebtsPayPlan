# frozen_string_literal: true

module Services
  module Costs
    module ControllerParams
      class CreateControllerParams < BaseControllerParams
        def params
          @controller_params.require(:cost)
                            .permit(
                              :costable_type,
                              :costable_id,
                              :cost_value,
                              group_member_attributes: [:group_id]
                            )
        end
      end
    end
  end
end
