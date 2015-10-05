class NodeStatusController < ApplicationController
  def index
    @job = Job.find(params[:jobid])
    @node_statuses = @job.node_status_checkins
    respond_to do |format|
      format.csv { send_data @node_statuses.to_csv }
      format.json
    end
  end  
end