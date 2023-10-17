# frozen_string_literal: true

module Services
  module Groups
    module JoinHelperInterface
      def send?
        raise StandardError, 'not implemented'
      end

      def send
        raise StandardError, 'not implemented'
      end

      def error_message
        raise StandardError, 'not implemented'
      end
    end

    class JoinHelperBase
      include JoinHelperInterface

      def initialize(group, user)
        @group = group
        @user = user
      end
    end
  end
end
