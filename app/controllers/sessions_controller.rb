class SessionsController < ApplicationController
  
  def new

  end

  def create
    user = User.find_by(username: params[:session][:username].downcase) # users are stored as lower case, so search for the user with lowercase characters
    if user && user.authenticate(params[:session][:password])
      # Login success
      login(user)
      if(user.isAdmin)
        # Redirect to admin panel
        # redirect_to ...
        puts("User authenticated and is a admin")
      else
        # Redirect to user area
        # redirect_to ...
        redirect_to user
        puts("User authenticated and is a user")
      end
    else 
      # Login failed
      flash[:error] = "Login failed! Invalid username and password combination!"
      puts("User authentication failed")
      render 'new'
    end
  end

  def destroy
    # Simply logout
    logout
    redirect_to login_path
  end
end
