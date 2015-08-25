class UserController < ApplicationController
  before_filter :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:userid])

    # Todo: Display jobs created by users
    @user_jobs = @user.jobs
  end

  def new
    @user ||= User.new
  end

  def create
    # Todo: verify password's match

    u = User.create(user_params)

    if u.persisted?
      flash[:notice] = "Account #{u.email} created successfully"
      redirect_to users_path
    else
      flash[:alert] = u.errors.full_messages.join("\n")
      # Todo: change this to use creation path
      redirect_to root_path
    end
  end

  def edit
    @user = User.find(params[:userid])
  end

  def update
    @user = User.find(params[:userid])
    @user.update_attributes(user_params)

    if @user.save!
      flash[:notice] = "Account #{@user.email} updated successfully"
      redirect_to users_path
    else
      flash[:alert] = @user.errors.full_messages.join("\n")
      redirect_to user_path(@user)
    end
  end

  def destroy
    @user = User.find(params[:userid])

    @user.destroy

    if @user.destroyed?
      flash[:notice] = "Account #{@user.email} deleted successfully"
      redirect_to users_path
    else
      flash[:alert] = @user.errors.full_messages.join("\n")
      redirect_to user_path(@user)
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :admin)
  end
end
