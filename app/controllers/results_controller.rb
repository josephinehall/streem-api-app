class ResultsController < ApplicationController

  # GET /results
  def index
    if results_params.permitted?
      @results = Result.create!(prepare_attributes(results_params))
      json_response(@results)  
    end
  end

  private

  def results_params
    # whitelist params
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
