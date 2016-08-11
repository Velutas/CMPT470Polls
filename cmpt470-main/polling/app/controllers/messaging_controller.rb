class MessagingController < ApplicationController
  def new
    if !logged_in?
        login_block
    else
      @user = current_user
      @message = Message.new
      friend_map
    end
  end

  def send_msg
    if !logged_in?
      login_block
    else
      @message = Message.new(message_params)
      if @message.from_id == current_user.id
        if @message.save()
          flash[:info] = "Message sent."
          redirect_to '/message/' + @message.id.to_s
        else
          @user = current_user
          friend_map
          render :new
        end
      else
        flash[:error] = "Unauthorized message sending."
        redirect_to(:back)
      end
    end
  end

  def reply
    if !logged_in?
      login_block
    else
      if current_user.id.to_s == params[:recipient_id].to_s
        logger.debug(params)
        @message = Message.new(message_params)
        if @message.save()
          flash[:info] = "Message sent."
          redirect_to '/message/' + @message.id.to_s
        else
          @user = current_user
          friend_map
          render :new
        end
      else
        flash[:error] = "You can't reply to someone else's message. " + current_user.id.to_s + ", " + params[:recipient_id].to_s
        redirect_to(:back)
      end
    end
  end

  def show
    if !logged_in?
      login_block
    else
      @received_message = Message.find(params[:id])
      # Don't show to anyone but the two people involved
      if @received_message.to_id == current_user.id || @received_message.from_id == current_user.id
        if (@received_message.seen == false) && (current_user.id == @received_message.to_id)
          @received_message.update(seen: true)
        end
        # Initialize variables in case the user replies to the message.
        @user = current_user
        @message = Message.new
        @message.to_id = @received_message.to_id
      else
        flash[:error] = "Unauthorized to view other users' messages."
        redirect_to(:back)
      end
    end
  end

  def index
    if !logged_in?
        login_block
    else
      @inbox = Message.where(to_id: current_user.id)
      @outbox = Message.where(from_id: current_user.id)
    end
  end

  private

  def message_params
      params.require(:message).permit(:id, :from_id, :to_id, :title, :content)
  end

  def friend_map
    @friend_map = []
    counter = 0
    get_friends(current_user.id).each do |friend|
      if friend.from_id == current_user.id
        @friend_map[counter] = [ User.find(friend.to_id).name, friend.to_id ]
      else
        @friend_map[counter] = [ User.find(friend.from_id).name, friend.from_id ]
      end
      counter += 1
    end
  end

end
