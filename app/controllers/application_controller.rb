class ApplicationController < ActionController::Base

    helper_method :current_user # to be able to use in views

    def login_user!(user)
        session[:session_token] = user.reset_session_token!
    end

    def current_user
        return nil unless session[:session_token]
        @current_user ||= User.find_by(session_token: session[:session_token])
    end
    
    def logout_user!
        current_user.reset_session_token!
        session[:session_token] = nil
    end

    def require_no_user!    # when attempting to login/signup ==> redirect to home if already logged in
        redirect_to cats_url if current_user
    end
    
    def require_user!
        redirect_to new_session_url if current_user.nil?
    end

    
    
end
