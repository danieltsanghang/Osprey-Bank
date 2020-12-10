class Admin::AccountsController < ApplicationController

  before_action :redirect_to_login_if_not_admin

  helper_method :sort_column

  ACCOUNTS_PER_PAGE = 20 #Number of accounts to be displayed per page

  def index
      @page = params.fetch(:page, 0).to_i


      if (params.has_key?(:user_id))
          @accounts = get_accounts_by_user
      else
          @accounts = Account.all
      end

      #If search box has been used to query
      if(params.has_key?(:search_account))
          @accounts = search()
      end

      @accounts = filter(@accounts)

      # Route for CSV file
      respond_to do |format|
          format.html
          format.csv { send_data Account.export_csv(@accounts) } # Send the data to the Account model along with the current_user
      end

      paginate # Paginate the page
      @accounts = @accounts[@page * ACCOUNTS_PER_PAGE, ACCOUNTS_PER_PAGE] # Set the variable to contain all accounts in the current page

  end

  def show
      @account = Account.find(params[:id])
  end

  def new

  end

  def create

  end

  def edit
      @account = Account.find(params[:id])
  end

  def update

  end

  def delete

  end

  def destroy

  end

  private

      def sort_column
          Account.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
      end

      # Function to search for certain accounts
      def search
          return @accounts.select{|el| el.created_at.to_s.starts_with?(params[:search_account]) || el.id.to_s.starts_with?(params[:search_account]) ||
            el.user_id.to_s.starts_with?(params[:search_account]) || el.accountNumber.to_s.starts_with?(params[:search_account]) ||
            el.sortCode.to_s.starts_with?(params[:search_account]) || el.balance.to_s.starts_with?(params[:search_account]) ||
            el.currency.to_s.starts_with?(params[:search_account])}
      end

      #Returns all accounts of a user
      def get_accounts_by_user
          return User.find(params[:user_id]).accounts
      end

      # Function that paginates the transactions into different pages
      def paginate
          @max_pages = (@accounts.size/ACCOUNTS_PER_PAGE) + 1
          if(@max_pages == 0)
              @max_pages = 1 # Because @max_pages indexes from 0, if its 0 change it to 1
          end

          # Boundary conditions for pages, a user should not be able to paginate under 0 or over the max limit
          if(@page >= @max_pages || @page < 0)
              redirect_to admin_accounts_path
          end
      end
end
