module PollsHelper
    def setup_user(poll)
        poll.ans ||= Answer.new
        2.times {poll.answers.build }
        poll
    end
    def get_votes(poll_id, answer_id)
        Vote.where(:poll_id => poll_id, :answer_id => answer_id).count
    end
end
