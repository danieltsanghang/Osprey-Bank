class Admin::GeneratorController < ApplicationController

      def new
      end

      def create
        if(params[:generator][:userid].present?)
            userGenerateTransaction(params[:generator][:userid].to_i, params[:generator][:transactions].to_i)
            redirect_to(admin_transactions_url)
        else
            #simple form error checks
            if params[:generator][:users].empty?
                flash[:alert] = "Cannot generate without any users entered"
                render 'new'
                return
            end
            if params[:generator][:accounts].empty? && !params[:generator][:transactions].empty?
                flash[:alert] = "Cannot generate transactions without accounts"
                render 'new'
                return
            end

            #generate fake users, accounts and transactions
            generateUsers(params[:generator][:users].to_i)
            generateAccounts(params[:generator][:accounts].to_i, params[:generator][:users].to_i)
            generateTransactions(params[:generator][:transactions].to_i, params[:generator][:accounts].to_i)

            redirect_to(admin_users_url)
        end
      end

end
