# frozen_string_literal: true

module LogbookClient
  module Requests
    class GetDocumentsRequest
      PATH = 'collections/%<collection_id>s/documents'

      def initialize(collection_id, search_term)
        @collection_id = collection_id
        @search_term = search_term
      end

      def method = :get
      def path = format(PATH, collection_id:)
      def body = { search: { term: search_term } }
      def options = {}

      private

      attr_reader :collection_id, :search_term
    end
  end
end
