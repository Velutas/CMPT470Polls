module FriendsHelper
    def get_friends(user_id)
        return Friend.where(accepted: true, from_id: user_id).all | Friend.where(accepted: true, to_id: user_id).all
    end
end
