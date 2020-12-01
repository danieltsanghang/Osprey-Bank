class UsersController < ApplicationController

  #before_action :redirect_to_login_if_not_logged_in

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

    def user_params
      params.require(:user).permit(:fname, :lname, :username, :email, :phoneNumber, :address)
    end

end
