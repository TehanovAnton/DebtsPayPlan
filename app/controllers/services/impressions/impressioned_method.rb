# frozen_string_literal: true

module Services
  module Impressions
    module ImpressionedMethod
      def impressioned?
        raise StandardError, 'Not implemented'
      end
    end
  end
end
