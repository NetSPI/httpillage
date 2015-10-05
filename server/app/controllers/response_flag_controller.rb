class ResponseFlagController < ApplicationController
  def index
    @flags = Job.find(params[:jobid]).response_flags
    respond_to do |format|
      format.csv { send_data @flags.to_csv }
      format.json
    end
  end  

  #
  # This will be called via ajax
  def show
    @response = ResponseFlag.find(params[:matchId])

    render :json => @response
  end

  def responses_since_timestamp
    matches = ResponseFlag.matches_since_timestamp(params[:jobid], params[:timestamp])

    render :json => { :newTimestamp => DateTime.now.utc, :matches => matches }
  end
end