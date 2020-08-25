require 'hanami/interactor'

class Search
  include Hanami::Interactor

  expose :results

  def initialize
    # set up the object
  end

  def call(attributes)
    @results = find_results(search_definition)
    search = search_definition(prepare(attributes))
  end

  private

  def prepare(attributes)
    attributes.merge(
      before: parse(attributes[:before]),
      after: parse(attributes[:after])
      ).to_h.symbolize_keys
  end

  def parse(timestamp)
    timestamp ? DateTime.strptime(timestamp,'%Q') : nil
  end

  def find_results(search_definition)
    SearchClient.search(search_definition)
  rescue Elasticsearch::Transport::Transport::Errors::BadRequest,
         Elasticsearch::Transport::Transport::Errors::ServiceUnavailable,
         Elasticsearch::Transport::Transport::Errors::NotFound => e
    raise e
  end
end
