class SessionsController < ApplicationController
    # before_action :logged_in_redirect, Only: [:new, :create]

    def new   
    end

    def create
      user = User.find_by(email: params[:session][:email].downcase)
      
      if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:success] = "Logged in successfully"
        
        if user.admin?
          redirect_to users_url
        else
          redirect_to user
        end
      else
        flash[:error] = "Invalid email or password. Please try again."
        redirect_to login_path
      end
    end

    def destroy
          session[:user_id] = nil
          flash[:success] = "You have successfully logged out."
          redirect_to login_path
    end

    private

    def logged_in_redirect
      if logged_in?
        flash[:error] = "You are already logged in."
        redirect_to root_path
      end
    end
end
