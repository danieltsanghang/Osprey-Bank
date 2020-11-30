class AccountsController < ApplicationController

  #before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_404_if_not_authorized

  def show
    @accounts = Account.where("user_id = ?", params[:id]) #obtain array of accounts
  end



  private

      def redirect_to_404_if_not_authorized
        redirect_to_login_if_not_logged_in

        unless(params.has_key?(:id))
          redirect_to_404
        else
          unless(User.exists?(params[:id]) && User.find(params[:id]).id == current_user.id)
            redirect_to_404
          end
        end
      end

end
