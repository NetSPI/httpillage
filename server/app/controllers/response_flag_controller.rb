class ResponseFlagController < ApplicationController
  #
  # This will be called via ajax
  def show
    @response = ResponseFlag.find(params[:matchId])

    render :json => @response
  end
end