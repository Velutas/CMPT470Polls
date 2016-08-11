class FriendsController < ApplicationController
    def create
        @friend = Friend.new(friend_params)
        if @friend.save
            flash[:info] = "Friend request sent."
        else
            flash[:error] = "You've already sent this user a friend request." 
        end
        redirect_to(:back)
    end

    def accept
        @friend = Friend.find(params[:id])
        if @friend.update(accepted: true)
            flash[:info] = "You accepted " + User.find(@friend.id).name + "'s request!"
        else
            flash[:error] = "That request no longer exists." 
        end
        redirect_to(:back)
    end

    def reject
        @friend = Friend.find(params[:id])
        if @friend.delete(@friend.id)
            flash[:info] = "You rejected " + User.find(@friend.id).name + "'s request."
        else
            flash[:error] = "That request no longer exists." 
        end
        redirect_to(:back)
    end

    def accept_suggestion
        @suggestion = Suggestion.find(params[:suggest_id])
        @suggestion.update(accepted: true)

        if Friend.find_by(:from_id => current_user.id, :to_id => params[:friend_id]) || Friend.find_by(:from_id => current_user.id, :to_id => params[:friend_id])
            flash[:info] = "It looks like there's already a friend request pending with this person!"
        else
            @friend = Friend.new(:from_id => current_user.id, :to_id => params[:friend_id])
            if @friend.save
                flash[:info] = "Friend request sent."
            else
                flash[:error] = "You've already sent this user a friend request." 
            end    
        end
        redirect_to(:back)
    end

    def reject_suggestion
        @suggestion = Suggestion.find(params[:suggest_id])
        @suggestion.update(accepted: true)
        flash[:info] = "You didn't connect with " + User.find(params[:friend_id]).name + "."
        redirect_to(:back)
    end

    def friend_params
        params.require(:friend).permit(:id, :to_id, :from_id)
    end

end
