# frozen_string_literal: true

module Services
  module Costs
    module Setters
      class GroupSetter < BaseSetter
        def set
          @group = @definer.define
        end
      end
    end
  end
end
