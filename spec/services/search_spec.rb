RSpec.describe Search do
  let(:service) { Search.new }
  let(:attributes) { Hash[query: 'scott morrison', before: 1554037199999, after: 1551358800000, interval: '1d'] }

  context 'correct input' do
    let(:search) { service.call(attributes) }

    it 'succeeds' do
      expect(search.successful?).to be(true)
    end

    it 'returns results' do
      expect(search.results).not_to be_empty
    end

    it 'returns more than one hit' do
      expect(search.results['hits']['hits'].count).to be > 0
    end
  end
end
