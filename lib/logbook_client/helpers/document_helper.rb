# frozen_string_literal: true

module LogbookClient
  module Helpers
    module DocumentHelper
      HASH_PARSER_REGEX = /(")|{|}|\s/

      ## General helpers

      # search_terms_to_hash(string) => hash
      # example:
      # searchable_term = 'integration_id:009f0ec4-84cd-4fc1-b099-64f76f29b12c,log_type:incoming'
      # searchable_term_to_hash(searchable_term)
      # => { integration_id: '009f0ec4-84cd-4fc1-b099-64f76f29b12c', log_type: 'incoming' }
      def search_term_to_hash(searchable_terms)
        searchable_terms.split(',').to_h do |term|
          term.split(':')
        end.deep_symbolize_keys
      end

      ## Helpers used on Document class

      # to_reference_id(hash) => string
      # example:
      # params = { integration_id: '009f0ec4-84cd-4fc1-b099-64f76f29b12c', log_type: 'incoming' }
      # to_reference_id(params)
      # => 'integration_id:009f0ec4-84cd-4fc1-b099-64f76f29b12c--$/#--log_type:incoming'
      def to_reference_id(params)
        raise Error, 'This method only accepts a Hash to be parsed' unless params.is_a?(Hash)

        params.to_json.gsub(HASH_PARSER_REGEX, '').gsub(',', separator)
      end

      # to_searchable_terms(hash) => array
      # example:
      # params = { integration_id: '009f0ec4-84cd-4fc1-b099-64f76f29b12c', log_type: 'incoming' }
      # to_searchable_terms(params)
      # => ['integration_id:009f0ec4-84cd-4fc1-b099-64f76f29b12c', 'log_type:incoming']
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
