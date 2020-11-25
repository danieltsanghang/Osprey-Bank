class SessionsController < ApplicationController
  
  def new

  end

  def create
    user = User.find_by(username: params[:session][:username].downcase) # users are stored as lower case, so search for the user with lowercase characters
    if user && user.authenticate(params[:session][:password])
      # Login success
      login(user)
      puts("--------------------------------------------------")
      if(user.isAdmin)
        # Redirect to admin panel
        # redirect_to ...
        puts("User authenticated and is a admin")
      else
        # Redirect to user area
        # redirect_to ...
        puts("User authenticated and is a user")
      end
    else 
      # Login failed
      puts("User authentication failed")
      render 'new'
    end
  end

  def destroy
    # Simply logout
    logout
  end
end
