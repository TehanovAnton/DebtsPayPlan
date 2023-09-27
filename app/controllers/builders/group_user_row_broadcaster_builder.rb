module Builders
  module BuilderMethods
    def result
      raise StandardError, 'not implemented'
    end
  end

  class GroupUserRowBroadcasterBuilder
    include BuilderMethods

    def initialize(group, user)
      @group = group
      @user = user
    end

    def result
      Services::Broadcasters::Groups::GroupBroadcaster.new(
        @group,
        @target,
        @partial_loader.load
      )
    end

    def set_target(target)
      @target = target
    end

    def set_partial_loader(partial_loader)
      @partial_loader = partial_loader
    end
  end
end
