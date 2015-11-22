class SettingController < ApplicationController
  def index
    @node_key = Setting.find_by_key("nodeApi").val
    @user_token = current_user.api_token
  end

  def update
    token_type = params["settings_type"]

    if token_type == "user"
      current_user.api_token = SecureRandom.base64(64)
      
      if current_user.save
        flash[:notice] = "User API token successfully rotated"
      end
    elsif token_type == "node"
      setting = Setting.find_by_key("nodeApi")
      setting.val = SecureRandom.base64(64)

      if setting.save
        flash[:notice] = "Node API token successfully rotated"
      end
    end

    redirect_to settings_path
  end
end