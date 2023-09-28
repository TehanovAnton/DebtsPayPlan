# frozen_string_literal: true

module Builders
  module BuilderMethods
    def result
      raise StandardError, 'not implemented'
    end
  end

  class GroupUserRowBroadcasterBuilder
    include BuilderMethods

    attr_reader :group, :user

    def initialize(group, user)
      @group = group
      @user = user
    end

    def result
      Broadcasters::FirstUserGroupImpressionBroadcaster.new(
        @target,
        @partial_loader,
        @group,
        @user
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
