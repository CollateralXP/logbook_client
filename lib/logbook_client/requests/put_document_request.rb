# frozen_string_literal: true

module LogbookClient
  module Requests
    class PutDocumentRequest
      PATH = 'collections/%<collection_id>s/documents/%<document_id>s'

      def initialize(collection_id, document)
        @collection_id = collection_id
        @document = document
      end

      def method
        :put
      end

      def path
        format(PATH, collection_id:, document_id: document.id)
      end

      def options
        { form: document.to_put_params }
      end

      private

      attr_reader :collection_id, :document
    end
  end
end
