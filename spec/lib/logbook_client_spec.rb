# frozen_string_literal: true

RSpec.describe LogbookClient do
  describe 'VERSION' do
    it { expect(described_class::VERSION).to eq('0.4.1') }
  end

  describe '#search_term_to_hash' do
    subject(:search_term_to_hash) { described_class.search_term_to_hash(term) }

    let(:term) { 'integration_id:009f0ec4-84cd-4fc1-b099-64f76f29b12c,log_type:incoming' }

    it do
      expect(search_term_to_hash).to match(integration_id: '009f0ec4-84cd-4fc1-b099-64f76f29b12c',
                                           log_type: 'incoming')
    end
  end

  describe '#reference_id_to_hash' do
    subject(:reference_id_to_hash) { described_class.reference_id_to_hash(reference_id) }

    let(:reference_id) do
      'integration_id:009f0ec4-84cd-4fc1-b099-64f76f29b12c--$/#--log_type:incoming'
    end

    it do
      expect(reference_id_to_hash).to match(integration_id: '009f0ec4-84cd-4fc1-b099-64f76f29b12c',
                                            log_type: 'incoming')
    end
  end

  describe '#to_reference_id' do
    subject(:to_reference_id) { described_class.to_reference_id(params) }

    let(:params) { { integration_id: 1, log_id: 2, id: 3 } }

    it { is_expected.to eq('integration_id:1--$/#--log_id:2--$/#--id:3') }

    context 'when params is not valid' do
      let(:params) { 'invalid' }

      it 'raises the expected error' do
        expect { to_reference_id }.to raise_error(LogbookClient::Error,
                                                  'This method only accepts a Hash to be parsed')
      end
    end
  end

  describe '#to_searchable_terms' do
    subject(:to_searchable_terms) { described_class.to_searchable_terms(param) }

    context 'when param is a hash' do
      let(:param) { { integration_id: 1, log_id: 2, id: 3 } }

      it { is_expected.to eq(%w[integration_id:1 log_id:2 id:3]) }
    end

    context 'when the param is some document reference_id' do
      let(:param) { 'integration_id:1--$/#--log_id:2--$/#--id:3' }

      it { is_expected.to eq(%w[integration_id:1 log_id:2 id:3]) }
    end
  end
end
