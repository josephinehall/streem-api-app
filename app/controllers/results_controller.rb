class ResultsController < ApplicationController

  # GET /results
  def index
    search = Search.new.(results_params)
    if search.successful? && search.results
      json_response(search.results)
    else
      json_response({
        error: "Sorry! We couldn't find any results."
      })
    end
  end

  private

  def results_params
    params.permit(:query, :before, :after, :interval)
  end

  def parse(timestamp)
    DateTime.strptime(timestamp,'%s')
  end

  def prepare_attributes(attributes)
    attributes.merge(
      before: parse(attributes[:before]),
      after: parse(attributes[:after])
      )
  end
end
