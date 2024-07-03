# frozen_string_literal: true

require_relative 'logbook_client/api'
require_relative 'logbook_client/configuration'
require_relative 'logbook_client/document'
require_relative 'logbook_client/version'

module LogbookClient
  class Error < StandardError; end

  class << self
    extend Forwardable

    def_delegators :api_client, :health, :get_documents, :put_document

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def api_client
      @api_client ||= Api.new(configuration)
    end
  end
end
