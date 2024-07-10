# frozen_string_literal: true

module LogbookClient
  module Requests
    class GetDocumentsRequest
      PATH = 'collections/%<collection_id>s/documents'

      def initialize(collection_id, search_term, page: nil, per_page: nil)
        @collection_id = collection_id
        @search_term = search_term
        @page = page
        @per_page = per_page
      end

      def method = :get
      def path = format(PATH, collection_id:)
      def body = { search: { term: search_term } }
      def params = { page:, size: per_page }.compact_blank

      private

      attr_reader :collection_id, :search_term, :page, :per_page
    end
  end
end
