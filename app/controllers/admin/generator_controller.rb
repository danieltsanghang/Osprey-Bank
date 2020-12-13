class Admin::GeneratorController < ApplicationController
      def new

      end
      def create
        if(params[:generator][:userid].present?)
        userGenerateTransaction(params[:generator][:userid].to_i, params[:generator][:transactions].to_i)
        redirect_to(admin_transactions_url)
        else
          generateUsers(params[:generator][:users].to_i)
          generateAccounts(params[:generator][:accounts].to_i, params[:generator][:users].to_i)
          generateTransactions(params[:generator][:transactions].to_i, params[:generator][:accounts].to_i)

          redirect_to(admin_users_url)
            end
      end

end
