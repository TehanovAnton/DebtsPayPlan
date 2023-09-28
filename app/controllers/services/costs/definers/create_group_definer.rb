# frozen_string_literal: true

module Services
  module Costs
    module Definers
      class CreateGroupDefiner
        include DefinerMethod

        def initialize(group_id)
          @group_id = group_id
        end

        def define
          Group.includes(:users).find(@group_id)
        end
      end
    end
  end
end
