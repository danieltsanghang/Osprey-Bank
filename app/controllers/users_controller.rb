class UsersController < ApplicationController

  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_404_if_not_authorized

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(current_user.id)
      if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  # Sanitise inputs
    def user_params
      params.require(:user).permit(:fname, :lname, :username, :email, :phoneNumber, :address)
    end

    # Security check to make sure the user is accessing only their users page
    def redirect_to_404_if_not_authorized
      if(current_user.id !=  params[:id].to_i)
        redirect_to_404
        return
      end
    end

end
