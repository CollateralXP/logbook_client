# frozen_string_literal: true

module LogbookClient
  class Configuration
    DEFAULT_PARSER_SEPARATOR = '--$/#--'

    include ActiveModel::Model

    attr_accessor :api_token, :api_url, :searchable_terms_separator

    def initialize(attributes = {})
      super

      @searchable_terms_separator ||= DEFAULT_PARSER_SEPARATOR
    end
  end
end
