module Builders
  module Directors
    class GroupUserRowBroadcasterDirector < Director
      def initialize(builder, group, user)
        super(builder)

        @group = group
        @user = user
      end

      def build
        @builder.set_target(Broadcasters::Targets::GroupUserRowTarget.new(@group, @user).target)

        @builder.set_partial_loader(
          PartialLoaders::GroupsPartialsLoader.new(
            '/shared/groups/group_user_row',
            { group: @group, cur_user: @user, user: @user, index: 0 }
          )
        )
      end
    end
  end
end
