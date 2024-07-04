# frozen_string_literal: true

require_relative 'helpers/document_helper'

module LogbookClient
  class Document
    include ActiveModel::Model
    include Helpers::DocumentHelper

    attr_accessor :id, :created_at, :reference_id, :request, :response, :searchable_terms

    validates :searchable_terms, :reference_id, presence: true

    def initialize(attributes = {})
      @reference_id = parse_reference_id(attributes.delete(:reference_id))
      @searchable_terms = parse_searchable_terms(attributes.delete(:searchable_terms))

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

    def parse_reference_id(value)
      value.is_a?(Hash) ? to_reference_id(value) : value
    end

    def parse_searchable_terms(value)
      value.is_a?(Hash) ? to_searchable_terms(value) : value
    end
  end
end
