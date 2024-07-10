# frozen_string_literal: true

require 'http'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/module/delegation'
require 'active_support/notifications/instrumenter'
require 'active_model'
require_relative 'requests/health_request'
require_relative 'requests/put_document_request'
require_relative 'requests/get_documents_request'
require_relative 'requests/get_document_request'

module LogbookClient
  class Api
    InvalidDocumentError = Class.new(StandardError)
    InvalidSearchTermError = Class.new(StandardError)
    InvalidRequestError = Class.new(StandardError) do
      attr_reader :errors

      def initialize(message, errors = [])
        @errors = errors
        super(message)
      end
    end

    INSTRUMENT_NAMESPACE = 'logbook_client'

    def initialize(configuration)
      @configuration = configuration
    end

    ### GET requests
    def health
      request_with_rescue { Requests::HealthRequest.new }
    end

    def get_documents(collection_id, search_term = '', page: nil)
      raise InvalidSearchTermError, 'Search term must be an string' unless search_term.is_a?(String)

      request_with_rescue { Requests::GetDocumentsRequest.new(collection_id, search_term, page:) }
    end

    def get_document(collection_id, document_id)
      request_with_rescue { Requests::GetDocumentRequest.new(collection_id, document_id) }
    end

    ### PUT requests
    def put_document(collection_id, document)
      raise InvalidDocumentError, document.errors.full_messages unless document.valid?

      request_with_rescue { Requests::PutDocumentRequest.new(collection_id, document) }
    end

    private

    attr_reader :configuration

    delegate :api_url, :api_token, to: :configuration

    def request_with_rescue
      response = build_request(yield)

      raise_error(response) unless response.status.success?

      if response.parse.is_a?(Array)
        response.parse.map(&:deep_symbolize_keys)
      else
        response.parse.deep_symbolize_keys
      end
    rescue HTTP::Error => e
      raise InvalidRequestError, e.message
    end

    def build_request(request)
      HTTP.use(instrumentation: { instrumenter: ActiveSupport::Notifications.instrumenter,
                                  namespace: INSTRUMENT_NAMESPACE })
          .request(request.method, build_uri(request.path), **http_request_params(request))
    end

    def http_request_params(request)
      { json: (request.respond_to?(:body) && request.body.presence) || {},
        headers: default_headers.merge(request.respond_to?(:headers) ? request.headers : {}),
        params: request.respond_to?(:params) ? request.params.presence : {},
        **(request.respond_to?(:options) ? request.options : {}) }
    end

    def raise_error(response)
      errors = [response.parse['errors']].flatten

      raise InvalidRequestError.new(errors.first, errors)
    end

    def build_uri(path)
      [api_url, path].join('/')
    end

    def default_headers
      { 'X-Api-Token' => api_token, accept: 'application/json' }
    end
  end
end
