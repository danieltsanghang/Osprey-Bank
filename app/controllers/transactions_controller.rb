class TransactionsController < ApplicationController
    before_action :redirect_to_login_if_not_logged_in
    before_action :redirect_to_404_if_not_authorized

    TRANSACTIONS_PER_PAGE = 20 # This will be used for pagination, max number of transactionsin each page is 20

    def index
        puts(params)
        @page = params.fetch(:page, 0).to_i

        # Check wehther the user is accessing the transactions for a specific account or for all accounts a user has
        if(params.has_key?(:account_id))
            # Get transactions for a specific account
            transactions = get_transactions_from_account
        else
            # Get transactions for all accounts the user has
            transactions = get_transactions_from_user
        end

        @transactions_all = transactions.sort_by &:created_at # Sort the transactions
        paginate # Paginate the page
        @transactions_all = @transactions_all[@page * TRANSACTIONS_PER_PAGE, TRANSACTIONS_PER_PAGE] # Set the variable to contain all transactions in the current page
    end

    def new
        @transaction = Transaction.new
    end

    def show
      @transaction = Transaction.find(params[:id])
      @amount = Money.new(@transaction.amount)
    end

    def create
        @transaction = Transaction.new(transaction_params)
        if(@transaction.valid?)
            account = Account.find(params[:transaction][:sender_id]) # Find the sender account associated with transaction
            receiver_account = Account.find_by(id: params[:transaction][:receiver_id]) # Find the receiver account associated with transaction, if it exists

            if(account.balance - @transaction.amount >= 0) # Check if the transaction is even possible based on balance in account
                account.balance -= @transaction.amount

                if(!receiver_account.nil?) # Update the receiver's balance if they exist
                    receiver_account.balance += @transaction.amount
                    receiver_account.save
                end
                @transaction.save
                account.save
                redirect_to(transactions_path) # Redirect them to the transactions

            else
                flash[:error] = "Not enough money"
                redirect_to new_transaction_url # Redirect back to create a new transaction page and render error
            end
        else
            redirect_to new_transaction_url # Redirect back to create a new transaction page and render error
        end
    end

    private
        # Function redirects user to 404 if they are not logged in or authorized to view that account
        def redirect_to_404_if_not_authorized

            # If the user calls the index for their account, it's a GET request identifying the user by the session, hence not no need for further authentication
            unless(params.has_key?(:account_id))
                return
            end

            # Authentication for transactions for a specific account, authentication needs to be done
            unless(params.has_key?(:account_id) && Account.exists?(params[:account_id]) && Account.find(params[:account_id]).user_id == current_user.id)
                render file: "#{Rails.root}/public/404.html", layout: false, status: 404 # Render 404 page
            end
        end


        # Function that returns all the transaction a user has from all accounts
        def get_transactions_from_user
            # Get transactions for all accounts the user has
            transactions_sent = current_user.sent_transactions
            transactions_received = current_user.received_transactions
            return transactions_sent + transactions_received
        end


        # Function that returns all the transactions a user has from a specific account
        def get_transactions_from_account
            # Get transactions for a specific account
            account = Account.find(params[:account_id])
            transactions_sent = account.sent_transactions
            transactions_received = account.received_transactions
            return transactions_sent + transactions_received
        end

        # Function that paginates the transactions into different pages
        def paginate
            @max_pages = (@transactions_all.size/TRANSACTIONS_PER_PAGE)
            if(@max_pages == 0)
                @max_pages = 1 # Because @max_pages indexes from 0, if its 0 change it to 1
            end

            # Boundary conditions for pages, a user should not be able to paginate under 0 or over the max limit
            if(@page >= @max_pages || @page < 0)
                redirect_to transactions_path
            end
        end

        # Sanitise input params
        def transaction_params
            params.require(:transaction).permit(:sender_id, :receiver_id, :amount, :pages)
        end

end
