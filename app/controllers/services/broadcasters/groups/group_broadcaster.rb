module Services
  module Broadcasters
    module BroadcastMethod
      def broadcast
        raise StandardError, 'not implemented'
      end
    end

    module Groups
      class GroupBroadcaster
        include BroadcastMethod

        def initialize(group, target, partial)
          @group = group
          @target = target
          @partial = partial
        end

        def broadcast
          @group.broadcast_replace_to(
            @group,
            target: @target,
            html: @partial
          )
        end
      end
    end
  end
end