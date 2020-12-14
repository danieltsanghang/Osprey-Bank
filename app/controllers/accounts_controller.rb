class AccountsController < ApplicationController

  before_action :redirect_to_login_if_not_logged_in
  before_action :redirect_to_404_if_not_authorized

  def index
    @accounts = current_user.accounts #obtain array of accounts
  end

  def show
    @account = Account.find(params[:id])
    @currency = @account.currency
    @money = Money.new(@account.balance,@account.currency)
  end


  private

      def redirect_to_404_if_not_authorized
        
        # Admin should not be allowed to act like a regular user, i.e. view personal accounts, transactions, etc.
        redirect_to_login_if_admin

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
