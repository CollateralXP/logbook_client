# frozen_string_literal: true

module LogbookClient
  class Configuration
    DEFAULT_PARSER_SEPARATOR = '--$/#--'
    DEFAULT_HTTP_TIMEOUT_IN_SECONDS = 120

    include ActiveModel::Model

    attr_accessor :api_token, :api_url, :searchable_terms_separator, :http_timeout

    def initialize(attributes = {})
      super

      @searchable_terms_separator ||= DEFAULT_PARSER_SEPARATOR
      @http_timeout ||= DEFAULT_HTTP_TIMEOUT_IN_SECONDS
    end
  end
end
