module Builders
  module Directors
    class Director
      def initialize(builder)
        @builder = builder
      end

      def build
        raise StandardError, 'not implemented'
      end
    end
  end
end