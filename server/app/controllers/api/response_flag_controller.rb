class Api::ResponseFlagController < ApiController
  before_filter   :authorized_node?
  def create
    response_flag = ResponseFlag.new

    response_flag.job_id = params[:jobid]
    response_flag.node_id = params[:nodeid]
    response_flag.matched_string = params[:match_value]
    response_flag.http_response = Base64.decode64(params[:response])
    response_flag.payload = params[:payload]

    response_flag.save

    render :json => true
  end

  # This is for when Job response matches are in bulk mode.
  # I.e., Token collection
  def create_bulk
    # 
    matches = JSON.parse(params[:matches])

    matches.each do |match|
      response_flag = ResponseFlag.new
      response_flag.job_id = params[:jobid]
      response_flag.node_id = params[:nodeid]
      response_flag.matched_string = match["match"]
      response_flag.http_response = Base64.decode64(match["response"]) unless match["response"].nil?
      response_flag.payload = match["payload"]

      puts response_flag.inspect

      response_flag.save
    end

    render :json => true
  end
end
