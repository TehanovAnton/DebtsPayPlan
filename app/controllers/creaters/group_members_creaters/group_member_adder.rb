# frozen_string_literal: true

module Creaters
  module GroupMembersCreaters
    class GroupMemberAdder
      attr_accessor :group, :user

      def initialize(user, group)
        @user = user
        @group = group
      end

      def add
        group.users << user
      end
    end
  end
end
