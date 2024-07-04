# frozen_string_literal: true

module LogbookClient
  module Helpers
    module DocumentHelper
      HASH_PARSER_REGEX = /(")|{|}|\s/

      def to_reference_id(params)
        raise Error, 'This method only accepts a Hash to be parsed' unless params.is_a?(Hash)

        params.to_json.gsub(HASH_PARSER_REGEX, '').gsub(',', separator)
      end

      def to_searchable_terms(params_or_reference_id)
        result = if params_or_reference_id.is_a?(String)
                   params_or_reference_id
                 else
                   to_reference_id(params_or_reference_id)
                 end

        result.split(separator)
      end

      private

      def separator
        ((defined?(configuration) && configuration) ||
          ::LogbookClient.configuration).searchable_terms_separator
      end
    end
  end
end
