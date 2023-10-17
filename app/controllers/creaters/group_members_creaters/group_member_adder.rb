# frozen_string_literal: true

module Creaters
  module GroupMembersCreaters
    class GroupMemberAdder
      attr_accessor :group, :user, :error

      def initialize(user, group)
        @user = user
        @group = group
      end

      def add
        group.users << user
      end

      def add?
        return true unless group.users.include?(user)

        @error = 'User already in group'
        false
      end
    end
  end
end
