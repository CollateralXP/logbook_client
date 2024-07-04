# frozen_string_literal: true

require 'active_support/isolated_execution_state'
require 'active_support/notifications'

RSpec.describe LogbookClient::Api do
  let(:api) { described_class.new(configuration) }
  let(:api_token) { 'api_token' }
  let(:api_url) { 'https://logbook.collateralxp.com/api' }
  let(:configuration) { LogbookClient::Configuration.new(api_url:, api_token:) }
  let(:collection_id) { 'test-collection' }

  describe '#get_documents' do
    subject(:get_documents) { api.get_documents(collection_id, search_term) }

    let(:search_term) { 'integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408,log_type:incoming' }

    context 'when invalid search_term' do
      let(:search_term) { [] }

      it 'raises InvalidSearchTermError' do
        expect { get_documents }.to raise_error(described_class::InvalidSearchTermError)
          .with_message('Search term must be an string')
      end
    end

    context 'when collection not found' do
      let(:collection_id) { 'abobrinha' }

      before do
        stub_get_documents(collection_id, search_term, 404, { errors: 'Collection not found' })
      end

      it 'raises InvalidRequestError' do
        expect { get_documents }.to raise_error(described_class::InvalidRequestError)
      end
    end

    context 'when successful' do
      let(:expected_response) do
        { message: nil,
          success: true,
          response: {
            current_page: 1,
            entries: [{
              collection_id: 'd2c7daef-1209-4578-aa16-2f7601e82194',
              created_at: '2024-07-01T20:17:25Z',
              id: 'f423f069-fb4e-423e-960f-69dd11037320',
              method: nil,
              raw_headers: {
                request_headers: { 'Referrer-Policy': 'strict-origin-when-cross-origin',
                                   'X-Content-Type-Options': 'nosniff',
                                   'X-Download-Options': 'noopen',
                                   'X-Frame-Options': 'SAMEORIGIN',
                                   'X-Permitted-Cross-Domain-Policies': 'none',
                                   'X-XSS-Protection': '0' }
              },
              raw_request_payload: nil,
              raw_response_payload: nil,
              reference: 'integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408/' \
                         'log_id:02b31d8d-f674-4965-be2d-e1770f2c5dbd/' \
                         'log_type:incoming/' \
                         'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3/' \
                         'external_order_id:0|166924-01',
              status: '200',
              uri: 'http://localhost:3000/integrations/c59158ed-3b65-4e55-9a15-5251c9dfd408/' \
                   'webhooks'
            }],
            limit_value: 25, offset_value: 0, total_count: 1, total_pages: 0
          } }
      end

      before do
        stub_get_documents(collection_id, search_term, 200)
      end

      it { expect(get_documents).to eq(expected_response) }
    end
  end

  describe '#get_document' do
    subject(:get_document) { api.get_document(collection_id, document_id) }

    let(:document_id) { 'test-document' }
    let(:expected_response) do
      { message: nil,
        success: true,
        response: {
          collection_id: 'd2c7daef-1209-4578-aa16-2f7601e82194',
          created_at: '2024-07-02T18:46:02Z',
          id: '3f3e9467-2cfc-4257-9dae-756549b1237b',
          raw_headers: {
            request_headers: { 'x-mock-event-code': '1',
                               'x-mock-match-request-headers': 'x-mock-event-code' }
          },
          raw_request_payload: nil,
          raw_response_payload: nil,
          reference: 'integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408/' \
                     'log_id:73a21f45-b840-4aee-837b-908652cc7593/' \
                     'log_type:outgoing/' \
                     'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3/' \
                     'external_order_id:0|166924-01',
          request_method: nil,
          resource_file: {
            collection_id: 'd2c7daef-1209-4578-aa16-2f7601e82194',
            created_at: '2024-07-02T18:46:02Z',
            document_id: '3f3e9467-2cfc-4257-9dae-756549b1237b',
            reference_id: 'integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408/' \
                          'log_id:73a21f45-b840-4aee-837b-908652cc7593/' \
                          'log_type:outgoing/' \
                          'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3/' \
                          'external_order_id:0|166924-01',
            request: {
              headers: { request_headers: { 'x-mock-event-code': '1',
                                            'x-mock-match-request-headers': 'x-mock-event-code' } },
              payload: '{:userid=>"evaluationzone", ' \
                       ':password=>"1#lnP7930C", ' \
                       ':XML_MessageGroup=>"<?xml version=\"1.0\" encoding=\"utf-8\"?> ' \
                       '<MESSAGE_GROUP xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" ' \
                       'xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" _TRANS=\"0|166924-01\" ' \
                       '_EventCode=\"1\" _InitiatedBy=\"\" _ActionRequired=\"false\" ' \
                       '_ClientViewable=\"false\"> <_NoteCategory>Vendor Action</_NoteCategory> ' \
                       '<NOTE>Hello The report for the property located at 808 LARK ST, Fort ' \
                       'Walton Beach, FL 32547 was delivered by the appraiser and emailed to ' \
                       'the processors on file. For questions please call our office at ' \
                       '773-647-1992. AMC Name : EvaluationZone, Inc</NOTE> </MESSAGE_GROUP>"}',
              uri: 'https://291606e0-1bc1-4586-b686-10a0eeb0f649.mock.pstmn.io:' \
                   'vendor_workflow_event'
            },
            response: {
              code: '000',
              payload: '{"status":{"_condition":"SUCCESS","_code":"000",' \
                       '"_trans":"5143|109224-05"},"response_date_time":"2023-02-20 20:42:33Z"}'
            },
            searchable_terms: ['integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408',
                               'log_id:73a21f45-b840-4aee-837b-908652cc7593',
                               'log_type:outgoing',
                               'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3',
                               'external_order_id:0|166924-01',
                               'https:',
                               '291606e0-1bc1-4586-b686-10a0eeb0f649.mock.pstmn.io:' \
                               'vendor_workflow_event']
          },
          status: '000',
          uri: 'https://291606e0-1bc1-4586-b686-10a0eeb0f649.mock.pstmn.io:vendor_workflow_event'
        } }
    end

    before do
      stub_get_document(collection_id, document_id, 200)
    end

    it { expect(get_document).to eq(expected_response) }
  end

  describe '#put_document' do
    subject(:put_document) { api.put_document(collection_id, document) }

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

  # rubocop:disable Metrics/MethodLength
  def stub_get_documents(collection_id, search_term = '', response_status = 200,
                         response_body = nil)
    endpoint = ['https://logbook.collateralxp.com/api', 'collections', collection_id,
                'documents'].join('/')
    headers = { 'Accept' => 'application/json', 'X-Api-Token': 'api_token' }
    response_body ||= {
      success: true,
      message: nil,
      response: {
        total_count: 1,
        total_pages: 0,
        current_page: 1,
        limit_value: 25,
        offset_value: 0,
        entries: [{ id: 'f423f069-fb4e-423e-960f-69dd11037320',
                    collection_id: 'd2c7daef-1209-4578-aa16-2f7601e82194',
                    reference: 'integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408/' \
                               'log_id:02b31d8d-f674-4965-be2d-e1770f2c5dbd/log_type:incoming/' \
                               'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3/' \
                               'external_order_id:0|166924-01',
                    created_at: '2024-07-01T20:17:25Z',
                    method: nil,
                    uri: 'http://localhost:3000/integrations/' \
                         'c59158ed-3b65-4e55-9a15-5251c9dfd408/webhooks',
                    raw_headers: { request_headers: {
                      'X-Download-Options': 'noopen',
                      'X-Permitted-Cross-Domain-Policies': 'none',
                      'Referrer-Policy': 'strict-origin-when-cross-origin',
                      'X-XSS-Protection': '0',
                      'X-Content-Type-Options': 'nosniff',
                      'X-Frame-Options': 'SAMEORIGIN'
                    } },
                    raw_request_payload: nil,
                    status: '200',
                    raw_response_payload: nil }]
      }
    }

    stub_request(:get, endpoint)
      .with(headers:, body: { search: { term: search_term } })
      .to_return(status: response_status,
                 body: response_body.to_json,
                 headers: { 'Content-Type': 'application/json; charset=utf-8' })
  end

  def stub_get_document(collection_id, document_id, response_status = 200, response_body = nil)
    endpoint = ['https://logbook.collateralxp.com/api',
                'collections', collection_id, 'documents', document_id].join('/')
    headers = { 'Accept' => 'application/json', 'X-Api-Token': 'api_token' }
    response_body ||= {
      message: nil,
      success: true,
      response: {
        collection_id: 'd2c7daef-1209-4578-aa16-2f7601e82194',
        created_at: '2024-07-02T18:46:02Z',
        id: '3f3e9467-2cfc-4257-9dae-756549b1237b',
        raw_headers: {
          request_headers: { 'x-mock-event-code': '1',
                             'x-mock-match-request-headers': 'x-mock-event-code' }
        },
        raw_request_payload: nil,
        raw_response_payload: nil,
        reference: 'integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408/' \
                   'log_id:73a21f45-b840-4aee-837b-908652cc7593/' \
                   'log_type:outgoing/' \
                   'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3/' \
                   'external_order_id:0|166924-01',
        request_method: nil,
        resource_file: {
          collection_id: 'd2c7daef-1209-4578-aa16-2f7601e82194',
          created_at: '2024-07-02T18:46:02Z',
          document_id: '3f3e9467-2cfc-4257-9dae-756549b1237b',
          reference_id: 'integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408/' \
                        'log_id:73a21f45-b840-4aee-837b-908652cc7593/' \
                        'log_type:outgoing/' \
                        'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3/' \
                        'external_order_id:0|166924-01',
          request: {
            headers: { request_headers: { 'x-mock-event-code': '1',
                                          'x-mock-match-request-headers': 'x-mock-event-code' } },
            payload: '{:userid=>"evaluationzone", ' \
                     ':password=>"1#lnP7930C", ' \
                     ':XML_MessageGroup=>"<?xml version=\"1.0\" encoding=\"utf-8\"?> ' \
                     '<MESSAGE_GROUP xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" ' \
                     'xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" _TRANS=\"0|166924-01\" ' \
                     '_EventCode=\"1\" _InitiatedBy=\"\" _ActionRequired=\"false\" ' \
                     '_ClientViewable=\"false\"> <_NoteCategory>Vendor Action</_NoteCategory> ' \
                     '<NOTE>Hello The report for the property located at 808 LARK ST, Fort ' \
                     'Walton Beach, FL 32547 was delivered by the appraiser and emailed to ' \
                     'the processors on file. For questions please call our office at ' \
                     '773-647-1992. AMC Name : EvaluationZone, Inc</NOTE> </MESSAGE_GROUP>"}',
            uri: 'https://291606e0-1bc1-4586-b686-10a0eeb0f649.mock.pstmn.io:' \
                 'vendor_workflow_event'
          },
          response: {
            code: '000',
            payload: '{"status":{"_condition":"SUCCESS","_code":"000",' \
                     '"_trans":"5143|109224-05"},"response_date_time":"2023-02-20 20:42:33Z"}'
          },
          searchable_terms: ['integration_id:c59158ed-3b65-4e55-9a15-5251c9dfd408',
                             'log_id:73a21f45-b840-4aee-837b-908652cc7593',
                             'log_type:outgoing',
                             'integration_order_id:a0639383-9d91-4fee-89a0-3eef1373b2c3',
                             'external_order_id:0|166924-01',
                             'https:',
                             '291606e0-1bc1-4586-b686-10a0eeb0f649.mock.pstmn.io:' \
                             'vendor_workflow_event']
        },
        status: '000',
        uri: 'https://291606e0-1bc1-4586-b686-10a0eeb0f649.mock.pstmn.io:vendor_workflow_event'
      }
    }

    stub_request(:get, endpoint)
      .with(headers:)
      .to_return(status: response_status,
                 body: response_body.to_json,
                 headers: { 'Content-Type': 'application/json; charset=utf-8' })
  end
  # rubocop:enable Metrics/MethodLength

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
