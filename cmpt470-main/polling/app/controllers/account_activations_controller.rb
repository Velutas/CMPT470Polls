# Basic activation functionality based on code at railstutorial.com 
# (https://www.railstutorial.org/book/account_activation_password_reset)

class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            log_in user
            flash[:info] = "Account activated!"
            redirect_to user
        else
            flash[:error] = "Invalid activation link"
            redirect_to root_url
        end
    end
end
