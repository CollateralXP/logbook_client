# frozen_string_literal: true

RSpec.describe LogbookClient::Configuration do
  let(:config) { described_class.new }

  describe 'accessors' do
    describe 'api_token' do
      it do
        config.api_token = 'test_api_token_123'

        expect(config.api_token).to eq('test_api_token_123')
      end
    end

    describe 'api_url' do
      it do
        config.api_url = 'https://api.logbook.example.com'

        expect(config.api_url).to eq('https://api.logbook.example.com')
      end
    end
  end

  describe 'searchable_terms_separator' do
    it do
      config.searchable_terms_separator = '|'

      expect(config.searchable_terms_separator).to eq('|')
    end

    context 'when no given value' do
      it do
        expect(config.searchable_terms_separator).to eq(described_class::DEFAULT_PARSER_SEPARATOR)
      end
    end
  end

  describe 'http_timeout' do
    it do
      config.http_timeout = 30

      expect(config.http_timeout).to eq(30)
    end

    context 'when no given value' do
      it { expect(config.http_timeout).to eq(described_class::DEFAULT_HTTP_TIMEOUT_IN_SECONDS) }
    end
  end
end
