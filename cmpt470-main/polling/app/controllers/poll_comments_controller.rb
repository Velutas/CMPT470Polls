class PollCommentsController < ApplicationController
	def create		
		@poll = Poll.find(params[:poll_id])
		@poll_comment = @poll.poll_comments.create(comment_params)
		@poll_comment[:commenter_id] = current_user.id
		@poll_comment.commenter_id = current_user.id
		@theory = 1
		
		redirect_to poll_path(@poll)
	end
	
	def destroy
		@poll = Poll.find(params[:poll_id])
		@poll_comment = @poll.poll_comments.find(params[:id])
		@poll_comment.destroy
		respond_to do |format|
			format.html { redirect_to poll_path(@poll), notice: 'Comment Deleted.' }
			format.json { head :no_content }
		end
	end
	
	private
		def comment_params	
			params.require(:poll_comment).permit(:commenter_id, :body)
		end
end
