# frozen_string_literal: true

RSpec.describe LogbookClient::Document do
  describe '#initialize' do
    subject(:document) { described_class.new(attributes) }

    let(:attributes) do
      { reference_id:,
        searchable_terms:,
        request: { uri: 'uri', headers: { 'header' => 'value' }, payload: 'payload' },
        response: { code: 200, payload: 'response' } }
    end

    context 'when reference_id and searchable_terms are not parsed' do
      let(:reference_id) { { foo: 'bar', abo: 'brinha' } }
      let(:searchable_terms) { { foo: 'bar', abo: 'brinha' } }

      it { expect(document.reference_id).to eq('foo:bar--$/#--abo:brinha') }
      it { expect(document.searchable_terms).to eq(['foo:bar', 'abo:brinha']) }
    end

    context 'when reference_id and searchable_terms are parsed' do
      let(:reference_id) { 'foo:bar--$/#--abo:brinha' }
      let(:searchable_terms) { ['foo:bar', 'abo:brinha'] }

      it { expect(document.reference_id).to eq('foo:bar--$/#--abo:brinha') }
      it { expect(document.searchable_terms).to eq(['foo:bar', 'abo:brinha']) }
    end

    context 'when reference_id and searchable_terms are parsed with a different separator' do
      let(:reference_id) { 'foo:bar/abo:brinha' }
      let(:searchable_terms) { ['foo:bar', 'abo:brinha'] }

      it { expect(document.reference_id).to eq('foo:bar/abo:brinha') }
      it { expect(document.searchable_terms).to eq(['foo:bar', 'abo:brinha']) }
    end
  end
end
