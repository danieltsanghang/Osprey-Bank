class Admin::UsersController < ApplicationController
    
    before_action :redirect_to_login_if_not_admin

    helper_method :sort_column

    USERS_PER_PAGE = 20 # This will be used for pagination, max number of users in each page is 20

    def index
        @page = params.fetch(:page, 0).to_i # Current page in the table pagination
        @users = User.all

        if(params.has_key?(:search_user)) 
            @users = search()
        end

        @users = filter(@users)

        # Route for CSV file, no need to create a controller for it
        respond_to do |format|
            format.html
            format.csv { send_data User.export_csv(@users) } # Send the data to the Transaction model along with the current_user
        end

        paginate # Paginate the page
        @users = @users[@page * USERS_PER_PAGE, USERS_PER_PAGE] # Set the variable to contain all transactions in the current page
        
    end

    def show
       @user = User.find_by(id: params[:id])
       redirect_to_404 if @user.blank?
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(users_params)
        if(@user.valid?)
            @user.id = User.last.id + 1 # assign correct primary key in case of ID collisions with fake data
            @user.save
            redirect_to admin_user_url(@user)
        else
            render 'new'
        end
    end

    def edit
        @user = User.find_by(id: params[:id])
    end

    def update

    end

    def edit_password
        @user = User.find_by(id: params[:id])
    end

    def update_password
        @user = User.find_by(id: params[:id])
        @user.update(users_params)
        if(@user.save(context: :password_change)) # Add the context password_change to perform password change user model validations
            redirect_to admin_user_url(@user.id)
        else
            render :edit_password
        end
    end

    def delete
        @user = User.find(params[:id])
    end

    def destroy

    end

    private

        # Sanitise input
        def users_params
            params.require(:user).permit(:id, :fname, :lname, :email, :username, :password_digest, :isAdmin, :created_at, :DOB, :phoneNumber, :address, :pages, :sort, :direction, :search_user, :format, :password, :password_confirmation)
        end

        # Function used to sort a certain column, source: Rails cast episode 228: http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
        def sort_column
            User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
        end

        # Function used to search for a sender, receiver, amount or date
        def search
            return @users.select{|el|  el.created_at.to_s.starts_with?(params[:search_user]) || 
                el.id.to_s.starts_with?(params[:search_user]) || 
                el.fname.to_s.starts_with?(params[:search_user]) || 
                el.lname.to_s.starts_with?(params[:search_user]) || 
                el.email.to_s.starts_with?(params[:search_user]) || 
                el.username.to_s.starts_with?(params[:search_user]) || 
                el.isAdmin.to_s.starts_with?(params[:search_user]) || 
                el[:DOB].to_s.starts_with?(params[:search_user]) || 
                el.phoneNumber.to_s.starts_with?(params[:search_user]) || 
                el.address.to_s.starts_with?(params[:search_user])}
        end

        # Function that paginates the transactions into different pages
        def paginate
            @max_pages = (@users.size/USERS_PER_PAGE) + 1
            if(@max_pages == 0)
                @max_pages = 1 # Because @max_pages indexes from 0, if its 0 change it to 1
            end

            # Boundary conditions for pages, a user should not be able to paginate under 0 or over the max limit
            if(@page >= @max_pages || @page < 0)
                redirect_to admin_users_path
            end
        end
end
