class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    include SessionsHelper
    include UsersHelper
    include FriendsHelper
    attr_accessor :NumLoops

    def login_block
        flash[:error] = "Please log in to continue."
        redirect_to login_path
    end
    
end
