# frozen_string_literal: true

RSpec.describe LogbookClient::Helpers::DocumentHelper, type: :helper do
  describe '#search_term_to_hash' do
    subject(:search_term_to_hash) { helper.search_term_to_hash(term) }

    let(:term) { 'integration_id:009f0ec4-84cd-4fc1-b099-64f76f29b12c,log_type:incoming' }

    it do
      expect(search_term_to_hash).to match(integration_id: '009f0ec4-84cd-4fc1-b099-64f76f29b12c',
                                           log_type: 'incoming')
    end
  end
end
