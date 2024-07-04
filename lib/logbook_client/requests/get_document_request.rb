# frozen_string_literal: true

module LogbookClient
  module Requests
    class GetDocumentRequest
      PATH = 'collections/%<collection_id>s/documents/%<document_id>s'

      def initialize(collection_id, document_id)
        @collection_id = collection_id
        @document_id = document_id
      end

      def method = :get
      def path = format(PATH, collection_id:, document_id:)
      def options = {}

      private

      attr_reader :collection_id, :document_id
    end
  end
end
