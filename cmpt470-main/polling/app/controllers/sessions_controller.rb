class SessionsController < ApplicationController
    def new
    end
    
    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            # Activation check code sourced from railstutorial.org at
            # https://www.railstutorial.org/book/account_activation_password_reset#code-account_activation_email
            if user.activated?
                log_in user
                params[:session][:remember_me] == '1' ? remember(user) : forget(user)
                redirect_back_or user
            else
                flash[:error] = "Account not yet activated. Please check your email for the activation link."
                redirect_to root_url
            end
        else
            flash[:error] = "Invalid email / password"
            render 'new'
        end
    end

    def destroy
        log_out if logged_in?
        redirect_to root_url
    end
end
