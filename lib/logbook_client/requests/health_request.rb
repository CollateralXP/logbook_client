# frozen_string_literal: true

module LogbookClient
  module Requests
    class HealthRequest
      PATH = 'health'

      def method
        :get
      end

      def path
        PATH
      end

      def options
        {}
      end
    end
  end
end
