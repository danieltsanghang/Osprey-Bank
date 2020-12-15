module SessionsHelper

    # Log the user in and assign the session user_id to the user's ID
    def login(user)
        session[:user_id] = user.id
    end

    # Find the current user
    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    # Checks if the current user is an admin
    def is_admin?
        (logged_in? && (current_user.isAdmin == true))
    end

    # Checks if user is logged in
    def logged_in?
        !current_user.nil?
    end

    # Logs the user out by terminating the session
    def logout
        session.delete(:user_id)
        @current_user = nil # Clear the cached result of the current user
    end

    # Checks if the user is logged in, if not, redirect to login page
    def redirect_to_login_if_not_logged_in
      unless logged_in?
          redirect_to login_path
      end
    end

    # Checks if the user is logged in is an admin, if not, redirect to login page
    def redirect_to_login_if_not_admin
        unless(is_admin?)
            redirect_to login_path
        end
    end

    # Checks if the user is logged in is not an admin, if not, redirect to login page
    def redirect_to_login_if_admin
        if(is_admin?)
            redirect_to login_path
        end
    end
end
