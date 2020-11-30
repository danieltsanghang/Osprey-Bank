class UsersController < ApplicationController

  #before_action :redirect_to_login_if_not_logged_in

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update

  end  

end
