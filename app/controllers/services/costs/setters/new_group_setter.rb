# frozen_string_literal: true

module Services
  module Costs
    module Setters
      class NewGroupSetter < BaseSetter
        def set
          @group = @definer.define
        end
      end
    end
  end
end
