require 'hanami/interactor'

class Search
  include Hanami::Interactor

  expose :results

  def initialize
    # set up the object
  end

  def call(attributes)
    search_definition = prepare(attributes)
    @results = find_results(search_definition)
  end

  private

  def prepare(attributes)
    {
      index: ENV['ELASTICSEARCH_INDEX_NAME'],
      q: attributes[:query]
    }
  end

  def find_results(search_definition)
    SearchClient.search(search_definition)
  rescue Elasticsearch::Transport::Transport::Errors::BadRequest,
         Elasticsearch::Transport::Transport::Errors::ServiceUnavailable,
         Elasticsearch::Transport::Transport::Errors::NotFound => e
    exception_notifier.notify(e)
    raise e
  end
end
