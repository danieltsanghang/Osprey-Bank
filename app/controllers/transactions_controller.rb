class TransactionsController < ApplicationController
    before_action :redirect_to_login_if_not_logged_in
    before_action :redirect_to_404_if_not_authorized
    helper_method :sort_column, :sort_direction

    TRANSACTIONS_PER_PAGE = 20 # This will be used for pagination, max number of transactionsin each page is 20

    def index

        @page = params.fetch(:page, 0).to_i # Current page in the pagination

        # Check wehther the user is accessing the transactions for a specific account or for all accounts a user has
        if(params.has_key?(:account_id))
            # Get transactions and balance for a specific account
            transactions = get_transactions_from_account
            account = Account.find(params[:account_id])
            @balance = Money.new(account.balance, account.currency)
        else
            # Get transactions and balance for all accounts the user has
            transactions = get_transactions_from_user
            
            @balance = 0
            current_user.accounts.each do |el|
                @balance += Money.new(el.balance, el.currency).exchange_to('USD').fractional
            end
            @balance = Money.new(@balance, "USD")
        end

        # Search and filters for the results
        if(params.has_key?(:search_transaction)) 
            transactions = search(transactions)
        end

        @transactions_all = filter(transactions)

        # Route for CSV file
        respond_to do |format|
            format.html
            format.csv { send_data Transaction.export_csv(@transactions_all, current_user) } # Send the data to the Transaction model along with the current_user
        end
        
        paginate # Paginate the page
        @transactions_all = @transactions_all[@page * TRANSACTIONS_PER_PAGE, TRANSACTIONS_PER_PAGE] # Set the variable to contain all transactions in the current page
    end

    def new
        @transaction = Transaction.new
    end

    def show
      @transaction = Transaction.find(params[:id])
      @amount = convert(Money.new(@transaction.amount, (@transaction.sender.currency || @transaction.receiver.currency || 'USD')), params[:currency])
    end

    def create
        @transaction = Transaction.new(transaction_params)
        @transaction.amount *= 100 # Money objects use cents, so multiply by 100

        if(@transaction.valid?)
            @transaction.id = Transaction.last.id + 1 # assign correct primary key in case of ID collisions with fake data
            account = Account.find(params[:transaction][:sender_id]) # Find the sender account associated with transaction
            receiver_account = Account.find_by(id: params[:transaction][:receiver_id]) # Find the receiver account associated with transaction, if it exists

            if(account.balance - @transaction.amount >= 0) # Check if the transaction is even possible based on balance in account
                account.balance -= @transaction.amount

                if(!receiver_account.nil?) # Update the receiver's balance if they exist
                    # Currency conversion must take place
                    receiver_account.balance += Monetize.parse(convert(Money.new(@transaction.amount, account.currency), receiver_account.currency)).fractional.round(-1)
                    receiver_account.save
                end
                @transaction.save
                account.save
                redirect_to(transactions_path) # Redirect them to the transactions

            else
                flash[:error] = "Not enough money"
                render 'new'
            end
        else
            render 'new'
        end
    end

    private
        # Function redirects user to 404 if they are not logged in or authorized to view that account
        def redirect_to_404_if_not_authorized

            # Admin should not be allowed to act like a regular user, i.e. view personal accounts, transactions, etc.
            redirect_to_login_if_admin

            # If the user calls the index for their account, it's a GET request identifying the user by the session, hence not no need for further authentication
            unless(params.has_key?(:account_id))
                return
            end

            # Authentication for transactions for a specific account, authentication needs to be done
            unless(params.has_key?(:account_id) && Account.exists?(params[:account_id]) && Account.find(params[:account_id]).user_id == current_user.id)
                redirect_to_404 # Render 404 page
            end
        end

        # Sanitise input params
        def transaction_params
            params.require(:transaction).permit(:sender_id, :receiver_id, :amount, :pages, :sort, :direction, :search_transaction, :format)
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
            @max_pages = (@transactions_all.size/TRANSACTIONS_PER_PAGE) + 1
            if(@max_pages == 0)
                @max_pages = 1 # Because @max_pages indexes from 0, if its 0 change it to 1
            end

            # Boundary conditions for pages, a user should not be able to paginate under 0 or over the max limit
            if(@page >= @max_pages || @page < 0)
                redirect_to transactions_path
            end
        end

        # Function used to sort a certain column, source: Rails cast episode 228: http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
        def sort_column
            Transaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
        end

        # Function used to search for a sender, receiver, amount or date
        def search(transactions)
            return transactions.select{|el| el.sender_id.to_s.starts_with?(params[:search_transaction]) || 
                el.receiver_id.to_s.starts_with?(params[:search_transaction]) || 
                el.amount.to_s.starts_with?(params[:search_transaction]) || 
                el.created_at.to_s.starts_with?(params[:search_transaction])}
        end

end
