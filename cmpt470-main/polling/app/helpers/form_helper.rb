module FormHelper
	def setup_user(poll)
		poll.ans ||= Answer.new
		poll
	end
end
