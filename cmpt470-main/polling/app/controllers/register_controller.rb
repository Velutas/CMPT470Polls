class RegisterController < ApplicationController
    def index
        @user = User.new
    end
    
    def create
        @user =User.new(params[:user])
        if @user.save
            # Handle successful registration
        else
            render 'index'
        end
    end

end
