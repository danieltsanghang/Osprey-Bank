module SessionsHelper
    def login(user)
        session[:user_id] = user.id
    end

    def current_user
        if session[:user_id]
            User.find_by(id: session[:user_id])
        end
    end

    def logged_in?
        !current_user.nil?
    end

    def logout
        session.delete(:user_id)
    end
end
