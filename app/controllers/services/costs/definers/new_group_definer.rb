# frozen_string_literal: true

module Services
  module Costs
    module Definers
      class NewGroupDefiner
        include DefinerMethod

        def initialize(group_id)
          @group_id = group_id
        end

        def define
          Group.find(@group_id)
        end
      end
    end
  end
end
