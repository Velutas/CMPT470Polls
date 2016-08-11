# Basic controller code (new, create, etc) sourced from
# https://www.railstutorial.org/book/modeling_users
class UsersController < ApplicationController
    
    before_filter :privacy_maps, :only => [:edit, :update]

    def privacy_maps
        @type_map = [ 
            ['Normal', 'normal'], 
            ['Moderator', 'moderator'], 
            ['Administrator', 'admin'] 
        ]
        @contact_map = [ 
            ['Public', 'contacts_public'], 
            ['Friends Only', "contacts_friends"], 
            ['Private', "contacts_private"] 
        ]
        @response_map =  [ 
            ['Public', "responses_public"], 
            ['Friends Only', "responses_friends"], 
            ['Private', "responses_private"] 
        ]  
    end

    def new
        @user = User.new
    end
    
    def show
        @user = User.find(params[:id])
        
        @new_friend = Friend.new

        # Retrieve 30 random friends if the current user has permission
        if (
            # User is looking at their own profile
            (logged_in? && current_user.id == @user.id)  || 
            # The user's contact info is public
            (@user.contact_visibility == "contacts_public") || 
            # The user's contacts are friends only and a friend is looking at it
            ((@user.contact_visibility == "contacts_friends") && logged_in? && (
                Friend.where(from_id: @user.id, to_id: current_user.id, accepted: true).length > 0 ||
                Friend.where(to_id: @user.id, from_id: current_user.id, accepted: true).length > 0
                )
            )
        )

		
            @contacts = get_friends(@user.id).shuffle[0, 30]
        else
            @contacts = []
        end

        # Retrieve the user's 50 most recent poll responses and comments if the current user has permission
        if (
            # User is looking at their own profile
            (logged_in? && current_user.id == @user.id)  || 
            # The user's response info is public
            (@user.response_visibility == "responses_public") || 
            # The user's responses are friends only and a friend is looking at it
            ((@user.response_visibility == "responses_friends") && logged_in? && (
                Friend.where(from_id: @user.id, to_id: current_user.id, accepted: true).length > 0 ||
                Friend.where(to_id: @user.id, from_id: current_user.id, accepted: true).length > 0
                )
            )
        )
            @response_activity = Vote.where(user_id: @user.id).limit(50)
            @comments = PollComment.where(commenter_id: @user.id).limit(50)
        else
            @response_activity = []
            @comments = []
        end
        
        privacy_maps
    end

    # Registration mailing code sourced from 
    # https://www.railstutorial.org/book/account_activation_password_reset
    def create
        @user =User.new(user_params)
        if @user.save
            @user.send_activation_email
            flash[:info] = "Thanks for registering! Check your email to activate your account."
            redirect_to root_url
        else
            # @user.errors.full_messages.each do |error|
            #     logger.debug("Error: " + error)
            # end
            render 'new'
        end
    end

    def edit
        if logged_in?
            @user = User.find(current_user.id)
            privacy_maps
        else
            login_block    
        end
    end

    def show_friends

    end

    def notifications
        @new_notifications = notifications_amt > 0
    end

    def update_usertype
        @update_params = params.require(:user).permit(:id, :user_type)
        @user = User.find(@update_params[:id])
        # The option to edit user account types is hidden from non-admins, but check again for security
        # Admins cannot change eachother's user type.
        if current_user.user_type == "admin" && @user.user_type != "admin"
            if @user.update(user_type: @update_params[:user_type])
                flash[:info] = "Account type updated."
            else
                flash[:error] = "Error updating account."
            end
        else
            flash[:error] = "Insufficient permission."
        end
        redirect_to(:back)
    end

    def update
        @user = User.find(params[:id])
        privacy_maps

        # Check authentication and that the user is editing their own account
        if (@user.authenticate(params[:user][:old_password]) && @user.id == current_user.id)
            if @user.update_attributes(user_params)
                flash[:notice] = "Account Updated."
                redirect_to '/options' 
            else
                @user.errors.full_messages.each do |error|
                    logger.debug("Error: " + error)
                end
                render :edit
            end
        else
            flash[:error] = "Password Invalid."
            redirect_to '/options'
        end
    
    end

    def user_params
        params.require(:user).permit(:id, :name, :email, :password, :password_confirmation, :user_type, :contact_visibility, :response_visibility)
    end
        
end
