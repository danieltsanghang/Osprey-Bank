class Admin::GeneratorController < ApplicationController
      def new

      end
      def create
          generateUsers(params[:generator][:users].to_i)
          generateAccounts(params[:generator][:accounts].to_i, params[:generator][:users].to_i)
          generateTransactions(params[:generator][:transactions].to_i, params[:generator][:accounts].to_i)
          redirect_to(admin_users_url)
      end

end
