# frozen_string_literal: true

require_relative 'logbook_client/api'
require_relative 'logbook_client/configuration'
require_relative 'logbook_client/document'
require_relative 'logbook_client/version'

require_relative 'logbook_client/helpers/document_helper'

module LogbookClient
  Error = Class.new(StandardError)

  class << self
    extend Forwardable

    include Helpers::DocumentHelper

    def_delegators :api_client, :health, :get_documents, :get_document, :put_document

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
