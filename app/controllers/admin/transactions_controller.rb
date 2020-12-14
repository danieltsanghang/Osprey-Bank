class Admin::TransactionsController < ApplicationController

    before_action :redirect_to_login_if_not_admin

    helper_method :sort_column

    TRANSACTIONS_PER_PAGE = 20 # This will be used for pagination, max number of transactions in each page is 20

    def index
        @page = params.fetch(:page, 0).to_i # Current page in the table pagination

        if(params.has_key?(:account_id))
            # Get transactions for a specific account
            @transactions = get_transactions_from_account
        elsif(params.has_key?(:user_id))
            # Get transactions for all accounts for a specific user
            @transactions = get_transactions_from_user
        else
            # Get all transactions for all users
            @transactions = Transaction.all
        end
        
        # Search and filter through transactions if requested by user
        if(params.has_key?(:search_transaction)) 
            @transactions = search()
        end

        @transactions = filter(@transactions)

        # Route for CSV file
        respond_to do |format|
            format.html
            format.csv { send_data Transaction.export_csv(@transactions) } # Send the data to the Transaction model along with the current_user
        end

        paginate # Paginate the page
        @transactions = @transactions[@page * TRANSACTIONS_PER_PAGE, TRANSACTIONS_PER_PAGE] # Set the variable to contain all transactions in the current page
    end

    def show
        @transaction = Transaction.find(params[:id])
    end

    def create
        @transaction = Transaction.new(transaction_params)
        @transaction.amount *= 100 # Currency is stored in cents, so multiply by 100

        if(@transaction.valid?)
            @transaction.id = Transaction.last.id + 1 # assign correct primary key in case of ID collisions with fake data
            # If transaction invalid, meaning trying to send more money than a user has, then render ned with an error
            if(!(@transaction.sender.nil?) && (@transaction.sender.balance - @transaction.amount < 0))
                flash[:error] = "Not enough money"
                render 'new'
                return
            end
            @transaction.save
            # Update the balance of the users with the new transaction, if they exist
            update_balance

            redirect_to(admin_transaction_path(@transaction))
        else
            render 'new'
        end
    end

    def new
        @transaction = Transaction.new
    end

    def edit
        @transaction = Transaction.find(params[:id])
    end

    def update
        @transaction = Transaction.find(params[:id])
        
        give_back_money # Revert the sender and receiver's balance to what it was before the transaction occured, if they exist

        if(@transaction.update(transaction_params))
            @transaction.amount *= 100
            @transaction.save
            # Update the balance of the users with the new transaction, if they exist
            update_balance

            redirect_to(admin_transaction_path(@transaction)) # Redirect to the transaction show page

        else
            render 'edit' # Redirect back to create a new transaction page and render error
        end
    end

    def delete
        @transaction = Transaction.find(params[:id])
    end

    def destroy
        @transaction = Transaction.find(params[:id])

        give_back_money # Update the balance of the 2 users, if they exist

        @transaction.destroy
        redirect_to(admin_transactions_path)
    end

    private

        # Sanitise input params
        def transaction_params
            params.require(:transaction).permit(:id, :sender_id, :receiver_id, :amount, :created_at)
        end

        # Function used to sort a certain column, source: Rails cast episode 228: http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
        def sort_column
            Transaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
        end

        # Function used to search for a sender, receiver, amount or date
        def search
            return @transactions.select{|el|  el.created_at.to_s.starts_with?(params[:search_transaction]) || 
                el.id.to_s.starts_with?(params[:search_transaction]) || 
                el.sender_id.to_s.starts_with?(params[:search_transaction]) || 
                el.receiver_id.to_s.starts_with?(params[:search_transaction]) || 
                el.amount.to_s.starts_with?(params[:search_transaction])}
        end

        # Function that paginates the transactions into different pages
        def paginate
            @max_pages = (@transactions.size/TRANSACTIONS_PER_PAGE) + 1
            if(@max_pages == 0)
                @max_pages = 1 # Because @max_pages indexes from 0, if its 0 change it to 1
            end

            # Boundary conditions for pages, a user should not be able to paginate under 0 or over the max limit
            if(@page >= @max_pages || @page < 0)
                redirect_to admin_transactions_path
            end
        end

        # Get transactions for a specific account
        def get_transactions_from_account
            account = Account.find(params[:account_id])
            transactions_sent = account.sent_transactions
            transactions_received = account.received_transactions
            return transactions_sent + transactions_received
        end

        # Get transactions for all accounts the user has
        def get_transactions_from_user
            user = User.find(params[:user_id])
            transactions_sent = user.sent_transactions
            transactions_received = user.received_transactions
            return transactions_sent + transactions_received
        end

        # Give back the money to sender and take away money from receiver, if they exist
        def give_back_money
            if(@transaction.sender)
                @transaction.sender.balance += @transaction.amount
                @transaction.sender.save
                
            end

            if(@transaction.receiver)
                @transaction.receiver.balance -= Monetize.parse(convert(Money.new(@transaction.amount,findCurrency(@transaction.sender_id,@transaction.receiver_id,'sent')), @transaction.receiver.currency)).fractional
                @transaction.receiver.save
            end
        end

        # Update the balance of the users accordingly with the new transaction, if they exist
        def update_balance
            if(@transaction.sender)
                @transaction.sender.balance -= @transaction.amount
                @transaction.sender.save
            end

            if(@transaction.receiver)
                @transaction.receiver.balance += Monetize.parse(convert(Money.new(@transaction.amount,findCurrency(@transaction.sender_id, @transaction.receiver_id, 'sent')), @transaction.receiver.currency)).fractional
                @transaction.receiver.save
            end
        end

end
