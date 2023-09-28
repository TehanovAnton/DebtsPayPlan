# frozen_string_literal: true

module Builders
  module Directors
    class GroupUserRowBroadcastDirector < Director
      def build
        @builder.set_target(
          Broadcasters::Targets::GroupUserRowTarget.new(
            @builder.group,
            @builder.user
          ).target
        )

        @builder.set_partial_loader(
          PartialLoaders::GroupsPartialsLoader.new(
            '/shared/groups/group_user_row',
            {
              group: @builder.group,
              cur_user: @builder.user,
              user: @builder.user,
              index: 0
            }
          )
        )
      end
    end
  end
end
