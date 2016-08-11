class VotesController < ApplicationController

    def create
        @vote = Vote.new(vote_params)
        if @vote.save
            flash[:info] = 'Vote accepted! Thanks!'
            match_check(current_user)
            redirect_to '/polls/' + @vote.poll_id.to_s
        else
            flash[:error] = 'Your vote could not be accepted.'
            redirect_to '/polls/' + @vote.poll_id.to_s
        end
    end

    def update
        @vote = Vote.new(vote_params)
        if Vote.update(@vote.id, :answer_id => @vote.answer_id)
            flash[:info] = 'Vote accepted! Thanks!'
            match_check(current_user)
            redirect_to '/polls/' + @vote.poll_id.to_s
        else
            flash[:error] = 'Your vote could not be accepted.'
            redirect_to '/polls/' + @vote.poll_id.to_s
        end
    end

    private
        def vote_params
            params.permit(:id, :user_id, :poll_id, :answer_id)
        end

        # If the user has matched five answers with another user, send them a notification to connect.
        def match_check(user)
            @votes_by_user = Vote.find_by_sql("select user_id, count(*) from votes where answer_id in (select distinct answer_id from votes where user_id = " + user.id.to_s + ") and user_id != " + user.id.to_s + " group by user_id having count(*) >= 5;")
            if @votes_by_user && @votes_by_user.length > 0
                # Get a user the voter is not already friends with
                @votes_by_user.each do |v|
                    logger.debug("Match: " + v.user_id.to_s)
                    if !(Friend.where(from_id: current_user.id, to_id: v.user_id).length > 0 || Friend.where(to_id: current_user.id, from_id: v.user_id).length > 0)
                        @suggestion = Suggestion.new(:from_id => v.user_id, :to_id => current_user.id)
                        @suggestion.save
                        @suggestion2 = Suggestion.new(:to_id => v.user_id, :from_id => current_user.id)
                        @suggestion2.save
                        break
                    else
                end            
            end
        end
    end
end
