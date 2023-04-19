# frozen_string_literal: true

require 'active_support/isolated_execution_state'
require 'active_support/notifications'

RSpec.describe LogbookClient::Api do
  let(:api) { described_class.new(configuration) }
  let(:api_token) { 'api_token' }
  let(:api_url) { 'https://logbook.collateralxp.com/api' }
  let(:configuration) { LogbookClient::Configuration.new(api_url:, api_token:) }

  describe '#put_document' do
    subject(:put_document) { api.put_document(collection_id, document) }

    let(:collection_id) { 'test-collection' }

    context 'when document is invalid' do
      let(:document) { LogbookClient::Document.new }

      it 'raises InvalidDocumentError' do
        expect { put_document }.to raise_error(described_class::InvalidDocumentError)
          .with_message(/can't be blank/)
      end
    end

    context 'when document is valid' do
      let(:document) do
        LogbookClient::Document.new(
          searchable_terms: %w[foo bar],
          reference_id: 'test'
        )
      end

      context 'when successful' do
        before { stub_put_document(collection_id, document.id, 201) }

        it { expect(put_document).to eq(status: 'ok') }
      end

      context 'when fail' do
        before { stub_put_document(collection_id, document.id, 422, { errors: 'Failed' }) }

        it 'raises the error' do
          expect { put_document }.to raise_error(described_class::InvalidRequestError)
        end
      end
    end
  end

  describe 'instrumentation' do
    subject(:instrument) { api.health }

    let(:events) { [] }

    before do
      ActiveSupport::Notifications.subscribe('request.logbook_client') do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end

      stub_health(200)
      instrument
    end

    it { expect(events).not_to be_empty }
  end

  def stub_health(response_status, response_body = { status: 'ok' })
    endpoint = ['https://logbook.collateralxp.com/api', 'health'].join('/')
    headers = { 'Accept' => 'application/json', 'X-Api-Token': 'api_token' }

    stub_request(:get, endpoint)
      .with(headers:)
      .to_return(status: response_status,
                 body: response_body.to_json,
                 headers: { 'Content-Type': 'application/json; charset=utf-8' })
  end

  def stub_put_document(collection_id, document_id, status, response_body = { status: 'ok' })
    endpoint = ['https://logbook.collateralxp.com/api',
                'collections', collection_id, 'documents', document_id].join('/')
    headers = { 'Accept' => 'application/json', 'X-Api-Token': 'api_token' }

    stub_request(:put, endpoint)
      .with(headers:)
      .to_return(status:,
                 body: response_body.to_json,
                 headers: { 'Content-Type': 'application/json; charset=utf-8' })
  end
end
