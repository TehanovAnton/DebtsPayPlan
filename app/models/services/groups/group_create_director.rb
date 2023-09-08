# frozen_string_literal: true

module Services
  module Groups
    class GroupCreateDirector
      attr_reader :owner, :name, :group, :debt

      def initialize(name, owner)
        @owner = owner
        @name = name
      end

      def create
        create_group
        group_cost_creater.create
      end

      private

      def create_group
        @group = Group.create(name:, owner:)
      end

      def group_cost_creater
        @group_cost_creater ||= Creaters::CostsCreaters::GroupCostCreater.new(group)
      end
    end
  end
end
