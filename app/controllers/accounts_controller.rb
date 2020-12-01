class AccountsController < ApplicationController

  before_action :redirect_to_404_if_not_authorized

  def index
    @accounts = current_user.accounts #obtain array of accounts
  end

  def show
    @account = Account.find(params[:id])
  end


  private

      def redirect_to_404_if_not_authorized
        if (current_user.nil?) #check needed so function can return if user not logged in
          redirect_to_login_if_not_logged_in
          return
        end

        unless(params.has_key?(:id)) #if routing via index action then skip unauthorized account access
            return
        end

        if(Account.exists?(params[:id])) #if account exists
          unless(Account.find_by_id(params[:id]).user_id == current_user.id) #if user trying to access external account
            redirect_to_404
          end
        else
          redirect_to_404
        end

      end

end
