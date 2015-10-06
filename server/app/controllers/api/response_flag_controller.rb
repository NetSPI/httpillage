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
end