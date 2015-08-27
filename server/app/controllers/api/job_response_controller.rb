class Api::JobResponseController < ApiController

  def create
    response = JobResponse.new

    response.jobid = params[:jobid]
    response.nodeid = params[:nodeid]
    response.code = params[:response_code]
    response.response = Base64.decode64(params[:response])

    response.save

    render :json => true
  end
end