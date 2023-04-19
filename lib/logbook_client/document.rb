# frozen_string_literal: true

module LogbookClient
  class Document
    include ActiveModel::Model

    attr_accessor :id, :created_at, :reference_id, :request, :response, :searchable_terms

    validates :searchable_terms, :reference_id, presence: true

    def initialize(attributes = {})
      super

      @id ||= SecureRandom.uuid
      @created_at ||= Time.now.utc.iso8601
    end

    def to_put_params
      { document: HTTP::FormData::File.new(StringIO.new(content.to_json), filename: id) }
    end

    def to_h
      content.merge(id:, created_at:).deep_symbolize_keys
    end

    private

    def content
      {
        document_id: id,
        created_at:,
        reference_id:,
        request:,
        response:,
        searchable_terms: [searchable_terms].flatten.compact
      }
    end
  end
end
