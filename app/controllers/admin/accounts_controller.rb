class Admin::AccountsController < ApplicationController

  before_action :redirect_to_login_if_not_admin

  helper_method :sort_column

  ACCOUNTS_PER_PAGE = 20 # Number of accounts to be displayed per page

  def index
      @page = params.fetch(:page, 0).to_i # Current page in the table pagination


      if (params.has_key?(:user_id))
          # If admin is trying to view all accounts for a specific user 
          @accounts = get_accounts_by_user
      else
          @accounts = Account.all
      end

      # If search box has been used to query
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
      @account = Account.new
  end

  def create
      @account = Account.new(account_params)
      @account.balance *= 100 # format balance
      @account.id = params[:account][:id].present? ? params[:account][:id] : Account.last.id + 1 # assign correct primary key
      if (@account.valid?)
          @account.save
          redirect_to(admin_account_path(@account)) # redirect to account show

      else
          render 'new' #render same page and errors
      end
  end

  def edit
      @account = Account.find(params[:id])
  end

  def update
      @account = Account.find(params[:id])
      old_currency = @account.currency
      # update account
      if (@account.update(account_params))
          @account.balance *= 100

          @account.balance = Monetize.parse(convert(Money.new(@account.balance, old_currency), @account.currency)).fractional
          @account.save

          redirect_to(admin_account_path(@account))

      #render errors
      else
          render 'edit'
      end
  end

  def delete
      @account = Account.find(params[:id])
  end

  def destroy
      @account = Account.find(params[:id])
      @account.destroy
      redirect_to(admin_accounts_path)
  end

  private

      def account_params
          params.require(:account).permit(:id, :user_id, :sortCode, :balance, :currency)
      end

      def sort_column
          Account.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
      end

      # Function to search for certain accounts
      def search
          return @accounts.select{|el| el.created_at.to_s.starts_with?(params[:search_account]) || el.id.to_s.starts_with?(params[:search_account]) ||
            el.user_id.to_s.starts_with?(params[:search_account])  ||
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
