class SettingController < ApplicationController
  def index
    @node_key = Setting.find_by_key("nodeApi").val
    @user_token = current_user.api_token
  end
end