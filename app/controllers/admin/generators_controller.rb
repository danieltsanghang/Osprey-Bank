class Admin::GeneratorsController < ApplicationController
  before_action :redirect_to_login_if_not_admin
      def new
      end

      def create
          if(params[:generator][:users].to_i + User.all.size < 300)
           flash.now.alert = "You have more than 300 generated users"
           render 'new'
           return
          end
        if(params[:generator][:userid].present?)
            if params[:generator][:transactions].empty?
                flash.now.alert = "Please enter a valid amount of transactions"
            end
            if(User.find(params[:generator][:userid].to_i).accounts.size > 0)
                userGenerateTransaction(params[:generator][:userid].to_i, params[:generator][:transactions].to_i)
                redirect_to(admin_transactions_url)
            else
                flash.now.alert = "Cannot generate transactions for a user without any accounts"
                render 'new'
                return
            end
        else
            #simple form error checks
            if params[:generator][:users].empty?
                flash.now.alert = "Cannot generate without any users entered"
                render 'new'
                return
            end
            if params[:generator][:accounts].empty? && !params[:generator][:transactions].empty?
                flash.now.alert = "Cannot generate transactions without accounts"
                render 'new'
                return
            end

            #generate fake users, accounts and transactions
            generateUsers(params[:generator][:users].to_i)
            generateAccounts(params[:generator][:accounts].to_i, params[:generator][:users].to_i,params[:generator][:transactions].to_i)

            redirect_to(admin_users_url)
        end
      end

      def seed
        Rails.application.load_seed
        redirect_to(admins_url)
      end

end
