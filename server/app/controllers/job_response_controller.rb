class JobResponseController < ApplicationController
  #
  # This will be called via ajax
  def show
    @response = JobResponse.find(params[:responseid])

    render :json => @response
  end
end