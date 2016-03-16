class Api::CharsetController < ApiController
  def index
    render :json => Charset.all.to_json
  end
end