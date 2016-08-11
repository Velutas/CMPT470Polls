module UsersHelper
    # Returns the Gravatar for the given user.
    def gravatar_for(user, options = { size: 80 })
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
    
    def notifications_amt
        @user = User.find(current_user.id)
        @friend_requests = Friend.where(to_id: @user.id, accepted: false)
        @new_messages = Message.where(to_id: @user.id, seen: false)
        @suggestions = Suggestion.where(to_id: @user.id, accepted: false)
        @notifications_amt = @friend_requests.length + @new_messages.length + @suggestions.length
    end

end
