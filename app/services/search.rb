require 'hanami/interactor'
require 'elasticsearch/dsl'

class Search
  include Hanami::Interactor
  include Elasticsearch::DSL

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
  def search_definition(options = {})
    search do
      query do
        # Uses the Query String full text query type
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html
        bool do
          must do
            query_string do
              query options[:query]
            end
          end
          # Filters to results within the given period
          filter do
            range :timestamp do
              gte options[:after]
              lte options[:before]
            end
          end
        end
      end
      # The first aggregation is by interval, on the timestamp field
      aggregation :date_agg do
        date_histogram do
          field 'timestamp'
          interval options[:interval]

          # The second is by the field of "medium", eg: Radio, Online
          aggregation :term_agg do
            terms field: 'medium'
          end
        end
      end
    end
  end
  rescue Elasticsearch::Transport::Transport::Errors::BadRequest,
         Elasticsearch::Transport::Transport::Errors::ServiceUnavailable,
         Elasticsearch::Transport::Transport::Errors::NotFound => e
    raise e
  end
end
